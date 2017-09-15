module Utils
  class Updater

    attr_accessor :grouper
    def update_all
      import_all
      full_regroup
    end

    def logger
      @logger ||= Logger.new('log/importer.log')
    end

    def import_all(exclude = [])
      exclude += ['UpdateEntrez']
      all_updaters.each do |updater|
        updater_name = updater.class.to_s
        next if exclude.include? updater_name
        logger.info "Processing #{updater_name}..."
        updater.import
      end
      logger.info 'Imports complete!'
    end

    def full_regroup
      logger.info 'Deleting all groups...'
      delete_groups
      logger.info 'Restoring gene groups (importing entrez...)'
      restore_genes
      logger.info 'Grouping all...'
      group
      logger.info 'Postgrouping...'
      postgroup
      logger.info 'Regroup complete!'
    end

    def all_updaters
      if Rails.env == 'production'
        path = File.join(%w(/var www dgidb current app jobs update_*rb))
      else
        path = File.join(File.dirname(Rails.root), %w(dgi-db app jobs update_*rb))
      end
      @all_updaters ||= Dir.glob(path).map do |file|
        /(update_\w+)\.rb/
            .match(file)[1]
            .classify
            .constantize
            .new
      end
    end

    def delete_groups
      Utils::Database.delete_genes
      Utils::Database.delete_drugs
    end

    def restore_genes
      entrez = all_updaters.select{ |u| u.class.to_s == 'UpdateEntrez'}.first
      entrez.import
    end

    def group
      @grouper ||= Grouper.new
      @grouper.perform
    end

    def postgroup
      @postgrouper ||= PostGrouper.new
      @postgrouper.perform
    end
  end
end