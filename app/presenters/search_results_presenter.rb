include Genome::Extensions

class SearchResultsPresenter
    def initialize(search_results)
        @search_results = search_results
    end

    def ambiguous_results
        Maybe(grouped_results[:ambiguous])
    end

    def definite_results
        Maybe(grouped_results[:definite])
    end

    def no_results_results
        Maybe(grouped_results[:no_results])
    end

    def definite_interactions
        @d ||= definite_results.inject([]){|list, result| list += result.interactions}
        @d ||= []
    end

    def ambiguous_interactions
        @a ||= ambiguous_results.inject([]){|list, result| list += result.interactions}
        @a ||= []
    end

    private
    def grouped_results
        @grouped_results ||= @search_results.group_by do |result|
            if result.has_results?
                if result.is_ambiguous?
                    :ambiguous
                else
                    :definite
                end
            else
                :no_results
            end
        end
    end
end
