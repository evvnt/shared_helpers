module SharedHelpers
  module LoadMoreHelpers
    DEFAULT_BUTTON_TEXT = 'Load more'.freeze

    class LoadMoreButton
      COMPONENT_PARAMS = %i[presenter source text].freeze
      CONTEXT_PARAMS = %i[filter nav page search].freeze

      def initialize(context, **params)
        @context = context
        @meta = validate_params(params.slice(*COMPONENT_PARAMS))
        @params = default_params
                  .merge(reject_nil_params(params))
                  .except(*COMPONENT_PARAMS)
      end

      def call(calling_scope)
        content_id = SecureRandom.hex
        is_last_page = last_page?(@meta[:source])
        calling_scope.instance_exec(@meta, @params, content_id, is_last_page) do |meta, params, id, is_last_page|
          unless meta[:source].empty? || is_last_page
            content id: id do
              button meta[:text] do
                event :click do
                  replaces id, meta[:presenter], **params
                end
              end
            end
          end
        end
      end

      private

      include ::Commands::ValidateParams

      def last_page?(source)
        if source.respond_to?(:last_page?)
          source.last_page?
        else
          source.try(:current_page).to_i >= source.total_pages
        end
      end

      def default_params
        reject_nil_params(
          filter: current_filter,
          nav: current_nav,
          page: next_page,
          search: current_search
        )
      end

      def current_filter
        @context[:filter] if @context[:filter].present?
      end

      def current_nav
        @context[:nav] if @context[:nav].present?
      end

      def next_page
        @meta[:source].try(:current_page).to_i + 1
      end

      def current_search
        @context[:search] if @context[:search].present?
      end

      def reject_nil_params(**params)
        params
          .symbolize_keys
          .reject { |k, v| CONTEXT_PARAMS.include?(k) && v.nil? }
      end

      def schema
        Dry::Validation.Form do
          required(:presenter).filled
          required(:source).filled
          required(:text).filled(:str?)
        end
      end
    end

    def load_more_button(presenter, source:, text: DEFAULT_BUTTON_TEXT, **params)
      LoadMoreButton.new(
        context.symbolize_keys,
        presenter: presenter,
        source: source,
        text: text,
        **params
      ).call(self)
    end
  end
end
