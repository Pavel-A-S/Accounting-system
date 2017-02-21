module IncomesHelper
  def options_for_income_project
    Project.all.collect { |p| [p.name, p.id] }
  end
end
