class MigrateJob < ApplicationJob
  queue_as :default

  def perform()
    @microposts = Micropost.all
    @microposts.each do |micropost|
      if micropost.picture?
        filename = micropost.picture.cache_stored_file!
        if File.exist?(filename)
          micropost.picture_new.attach(io: File.open(filename),
                                       filename: micropost.picture.filename)
        end
      end
    end
  end
end
