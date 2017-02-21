module FilesHandler
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
  end

  def handle_files(object, method, files, main_dir)
    files.each do |f|
      dir = main_dir
      begin
        subfolder = "#{SecureRandom.urlsafe_base64}/"
      end while File.exist?(dir + subfolder)
      dir += subfolder
      file_name = f.original_filename
      file_path = Rails.root.join(f.path)
      new_file_path = Rails.root.join(dir, file_name)
      file_path_for_db = '/' + dir + file_name

      # Creating new folder if doesn't exist
      unless File.exist?(Rails.root.join(dir))
        FileUtils.mkdir_p(Rails.root.join(dir), mode: 0700)
      end

      unless File.exist?(new_file_path)
        FileUtils.mv(file_path, new_file_path)
      end

      if File.exist?(new_file_path)
        object.try(method).create(name: file_name, path: file_path_for_db)
      end
    end
  end

  def show_files(object, method, path)
    files = object.try(method)
    if !files.blank?
      capture do
        files.each do |f|
          concat link_to f.name, send(path, f.id)
          concat tag('br')
        end
      end
    else
      t(:no_files)
    end
  end

  def files_to_delete(object, method, path)
    files = object.try(method)
    if !files.blank?
      capture do
        files.each do |f|
          concat link_to f.name, send(path, f.id)
          concat ' '
          concat link_to "(#{t(:delete)})", send(path, f.id),
                         method: :delete,
                         data: { confirm: t(:delete_confirmation) }
          concat tag('br')
        end
        concat tag('br')
      end
    end
  end

end
