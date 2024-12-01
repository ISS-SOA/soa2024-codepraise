# frozen_string_literal: true

require_relative 'project_file_contributions'

module Views
  # View for folder contributions for a given project
  class ProjectFolderContributions
    def initialize(project, folder, index = nil)
      @project = Project.new(project)
      @folder = folder
      @index = index
    end

    def subfolders
      @folder.subfolders.map.with_index do |sub, index|
        ProjectFolderContributions.new(@project.entity, sub, index)
      end
    end

    def files
      @folder.base_files.map { |file| ProjectFileContributions.new(file) }
    end

    def full_path
      PathPresenter.to_folder(
        @project.owner_name, project_name, @folder.path
      )
    end

    def rel_path
      PathPresenter.path_leaf(@folder.path)
    end

    def percent_credit_of(contributor_view)
      PercentPresenter.call(num_lines_by(contributor_view),
                            @folder.total_credits)
    end

    # Returns the number of lines contributed by contributor displayed on view
    def num_lines_by(contributor_view)
      contributor = contributors.find do |c|
        (c.email == contributor_view.email) || (c.username == contributor_view.username)
      end

      return 0 if contributor.nil?

      @folder.credit_share.share[contributor.username]
    end

    def owner_name
      @project.owner_name
    end

    def project_name
      @project.name
    end

    def http_url
      @project.http_url
    end

    def contributors
      @folder.contributors.map { |contributor| Contributor.new(contributor) }
    end

    def num_contributors
      @folder.contributors.count
    end

    def any_subfolders?
      @folder.subfolders.any?
    end
  end
end
