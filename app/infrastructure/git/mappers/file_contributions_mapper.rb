# frozen_string_literal: true

require_relative 'blame_contributor'

module CodePraise
  module Mapper
    # Summarizes a single file's contributions by team members
    class FileContributions
      def initialize(file_report)
        @file_report = file_report
      end

      def build_entity
        Entity::FileContributions.new(
          file_path: filename,
          lines: contributions
        )
      end

      private

      def filename
        @file_report[0]
      end

      def file_path
        @file_path ||= Value::FilePath.new(filename)
      end

      def contributions
        summarize_line_reports(@file_report[1])
      end

      def summarize_line_reports(line_reports)
        line_reports.map.with_index do |report, index|
          LineContribution.new(report, index, file_path.language).to_entity
        end
      end
    end

    # Summarizes a single line's contribution by a team member
    class LineContribution
      def initialize(line_report, line_index, language)
        @line_report = line_report
        @line_index = line_index
        @language = language
      end

      def contributor = BlameContributor.new(@line_report).to_entity
      def code_str = BlameCodeString.new(@line_report['code']).strip_leading_tab
      def code = @language.new(code_str)
      def time = Time.at(@line_report['author-time'].to_i)
      def number = @line_index + 1

      def to_entity
        Entity::LineContribution.new(contributor:, code:, time:, number:)
      end
    end

    BlameCodeString = Struct.new(:code) do
      # remove leading tab from git blame code output
      def strip_leading_tab
        code[1..]
      end
    end
  end
end
