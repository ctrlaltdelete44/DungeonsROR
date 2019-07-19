class MigrateJob < ApplicationJob
  queue_as :default

  def perform()
    @microposts = Micropost.all
    @microposts.each do |micropost|
      if micropost.picture?
        filename = File.basename(URI.parse(micropost.picture.store_dir).to_s)
        micropost.picture_new.attach(io: File.open(micropost.picture.url),
                                     filename: filename)
      end
    end
  end
end
