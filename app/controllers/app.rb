# frozen_string_literal: true

require 'rack' # for Rack::MethodOverride
require 'roda'
require 'slim'
require 'slim/include'

module CodePraise
  # Web App
  class App < Roda # rubocop:disable Metrics/ClassLength
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'
    plugin :common_logger, $stderr

    use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    MESSAGES = {
      no_projs: 'Add a Github project to get started',
      invalid_url: 'Invalid URL for a Github project',
      proj_not_found: 'Could not find that Github project',
      proj_exists: 'Project already exists',
      db_error: 'Having trouble accessing the database',
      git_cant_clone: 'Could not clone this project',
      folder_not_found: 'Could not find that folder'
    }.freeze

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        # Get cookie viewer's previously seen projects
        session[:watching] ||= []

        # Load previously viewed projects
        projects = Repository::For.klass(Entity::Project)
          .find_full_names(session[:watching])

        session[:watching] = projects.map(&:fullname)

        flash.now[:notice] = MESSAGES[:no_projs] if projects.none?

        viewable_projects = Views::ProjectsList.new(projects)

        view 'home', locals: { projects: viewable_projects }
      end

      routing.on 'project' do
        routing.is do
          # POST /project/
          routing.post do
            gh_url = routing.params['github_url']
            unless (gh_url.include? 'github.com') &&
                   (gh_url.split('/').count == 5)
              flash[:error] = MESSAGES[:invalid_url]
              response.status = 400
              routing.redirect '/'
            end

            owner_name, project_name = gh_url.split('/')[-2..]

            # Add project to database
            project = Repository::For.klass(Entity::Project)
              .find_full_name(owner_name, project_name)

            unless project
              # Get project from Github
              begin
                project = Github::ProjectMapper
                  .new(App.config.GITHUB_TOKEN)
                  .find(owner_name, project_name)
              rescue StandardError => err
                App.logger.error err.backtrace.join("DB READ PROJ\n")
                flash[:error] = MESSAGES[:proj_not_found]
                routing.redirect '/'
              end

              # Add project to database
              begin
                Repository::For.entity(project).create(project)
              rescue StandardError
                flash[:error] = MESSAGES[:proj_exists]
                routing.redirect '/'
              end
            end

            # Add new project to watched set in cookies
            session[:watching].insert(0, project.fullname).uniq!

            # Redirect viewer to project page
            routing.redirect "project/#{project.owner.username}/#{project.name}"
          end
        end

        routing.on String, String do |owner_name, project_name|
          # DELETE /project/{owner_name}/{project_name}
          routing.delete do
            fullname = "#{owner_name}/#{project_name}"
            session[:watching].delete(fullname)

            routing.redirect '/'
          end

          # GET /project/{owner_name}/{project_name}
          routing.get do
            path = request.remaining_path
            folder_name = path.empty? ? '' : path[1..]

            # Get project from database instead of Github
            begin
              project = Repository::For.klass(Entity::Project)
                .find_full_name(owner_name, project_name)

              if project.nil?
                flash[:error] = MESSAGES[:proj_not_found]
                routing.redirect '/'
              end
            rescue StandardError
              flash[:error] = MESSAGES[:db_error]
              routing.redirect '/'
            end

            # Clone remote repo from project information
            begin
              gitrepo = GitRepo.new(project)
              gitrepo.clone unless gitrepo.exists_locally?
            rescue StandardError => err
              App.logger.error err.backtrace.join("GIT CLONE\n")
              flash[:error] = MESSAGES[:git_cant_clone]
              routing.redirect '/'
            end

            # Compile contributions for folder
            begin
              folder = Mapper::Contributions
                .new(gitrepo).for_folder(folder_name)
            rescue StandardError
              flash[:error] = MESSAGES[:folder_not_found]
              routing.redirect "/project/#{owner_name}/#{project_name}"
            end

            if folder.empty?
              flash[:error] = MESSAGES[:folder_not_found]
              routing.redirect "/project/#{owner_name}/#{project_name}"
            end

            proj_folder = Views::ProjectFolderContributions.new(project, folder)

            # Show viewer the project
            view 'project', locals: { proj_folder: }
          end
        end
      end
    end
  end
end
