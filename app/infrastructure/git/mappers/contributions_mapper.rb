# frozen_string_literal: true

module CodePraise
  module Mapper
    # Git contributions parsing and reporting services
    class Contributions
      def initialize(gitrepo)
        @gitrepo = gitrepo
      end

      def for_folder(folder_name)
        blame = Git::BlameReporter.new(@gitrepo, folder_name).folder_report

        Mapper::FolderContributions.new(
          folder_name,
          BlameReports.new(blame).parse
        ).build_entity
      end

      BlameReports = Struct.new(:blame_output) do
        def parse
          blame_output.to_h do |file_blame|
            BlameReport.new(file_blame).parse
          end
        end
      end

      BlameReport = Struct.new(:file_blame) do
        def parse
          name  = file_blame[0]
          blame = BlamePorcelain.parse_file_blame(file_blame[1])
          [name, blame]
        end
      end
    end
  end
end
