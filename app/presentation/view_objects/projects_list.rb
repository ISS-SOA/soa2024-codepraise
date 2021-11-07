# frozen_string_literal: true

require_relative 'project'

module Views
  # View for a a list of project entities
  class ProjectsList
    def initialize(projects)
      @projects = projects.map.with_index do |proj, index|
        Project.new(proj, index)
      end
    end

    def each(&show)
      @projects.each do |proj|
        show.call proj
      end
    end

    def any?
      @projects.any?
    end
  end
end
