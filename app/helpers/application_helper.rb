module ApplicationHelper
  include RightsDeterminer
  include FilesHandler

  def set_date(date, path)
    if date.try(:year) == DateTime.now.year
      name = date.localtime.strftime("%d.%m") rescue ''
    else
      name = date.localtime.strftime("%d.%m.%Y") rescue ''
    end
      link_to name, path, class: 'simple_link' if name
  end

  def show_source(name, path)
    name = truncate(name, length: 117)
    link_to name, path, class: 'simple_link' if name
  end

  def round_it(value, precision = 0)
    if value && value < 0
      -((-value).ceil(precision))
    else
      value.ceil(precision)
    end
  end

end
