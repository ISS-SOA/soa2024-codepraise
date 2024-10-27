# frozen_string_literal: true

require 'roda'
require 'slim'

module CodePraise
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css', js: 'table_row_click.js'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        projects = Repository::For.klass(Entity::Project).all
        view 'home', locals: { projects: }
      end

      routing.on 'project' do
        routing.is do
          # POST /project/
          routing.post do
            gh_url = routing.params['github_url'].downcase
            routing.halt 400 unless (gh_url.include? 'github.com') &&
                                    (gh_url.split('/').count >= 3)
            owner_name, project_name = gh_url.split('/')[-2..]

            # Get project from Github
            project = Github::ProjectMapper
              .new(App.config.GITHUB_TOKEN)
              .find(owner_name, project_name)

            # Add project to database
            Repository::For.entity(project).create(project)

            # Redirect viewer to project page
            routing.redirect "project/#{project.fullname}"
          end
        end

        routing.on String, String do |owner_name, project_name|
          # GET /project/{owner_name}/{project_name}
          routing.get do
            # Get project from database
            project = Repository::For.klass(Entity::Project)
              .find_full_name(owner_name, project_name)

            # Clone remote repo from project information
            gitrepo = GitRepo.new(project)
            gitrepo.clone unless gitrepo.exists_locally?

            # Compile contributions for folder specified in route path
            path = request.remaining_path
            folder_name = path.empty? ? '' : path[1..]
            folder = Mapper::Contributions
              .new(gitrepo).for_folder(folder_name)

            # Show viewer the project
            view 'project', locals: { project:, folder: }
          end
        end
      end
    end
  end
end
