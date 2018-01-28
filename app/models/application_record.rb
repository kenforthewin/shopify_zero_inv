class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # def self.top_objects_from_record(field, object, record, shop_id)
  #   sql = "SELECT #{field}, count(#{field}) FROM jsonb_to_recordset((SELECT jsonb_agg(c) FROM (SELECT jsonb_array_elements(#{object}) FROM #{record} WHERE shop_id=#{shop_id}) AS dt(c))) AS x(#{field} text) GROUP BY #{field}"
  #   ActiveRecord::Base.connection.execute(sql)
  # end

  # def self.top_text_from_record(field, record, shop_id)
  #   sql = "SELECT c, count(c) FROM (SELECT body->'#{field}' FROM #{record} WHERE shop_id=#{shop_id}) AS dt(c) GROUP BY c ORDER BY count(c) DESC"
  #   ActiveRecord::Base.connection.execute(sql)
  # end

  # def self.top_level_keys(field, record, shop_id)
  #   sql = "SELECT DISTINCT jsonb_object_keys(#{field}) FROM #{record} WHERE shop_id=#{shop_id}"
  #   result = ActiveRecord::Base.connection.execute(sql)
  #   keys = result.map{|r| r['jsonb_object_keys'] }
  #   top = {}
  #   keys.each do |key|
  #     result = self.top_text_from_record(key, 'orders', shop_id)
  #     byebug
  #   end
  # end


end
