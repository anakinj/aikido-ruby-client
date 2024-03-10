# frozen_string_literal: true

module Aikido
  # Represents a reponse that is paginated
  class PaginatedResponse
    include Enumerable

    def initialize(&block)
      @page_loader = block
      @pages = []
      load_page(0)
    end

    def each(&block)
      return enum_for(:each) unless block_given?

      loop.with_index do |_, index|
        page = load_page(index)
        break if page.empty?

        page.each(&block)
      end
    end

    private

    def load_page(page)
      @pages[page] ||= @page_loader.call(page)
    end
  end
end
