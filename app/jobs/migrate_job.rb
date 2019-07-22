class MigrateJob < ApplicationJob
  queue_as :default

  def perform()
    @microposts = Micropost.all
    @microposts.each do |micropost|
      if micropost.picture?
        micropost.picture.cache_stored_file!
        filename = micropost.picture.url
        if File.exist?(filename)
          micropost.picture_new.attach(io: File.open(filename),
                                       filename: micropost.picture.filename)
        end
      end
    end
  end
end
