module LocationEx
  def search_by_short str
    where("#{table_name}.name like '%#{str}%'").first
  end
  def all_by_short str
    where("#{table_name}.name like '%#{str}%'")
  end
end
