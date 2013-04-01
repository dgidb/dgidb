class TourFilter
  def self.filter(controller)
   if tour_data = TOURS[controller.params[:action]]
     controller.instance_variable_set('@tour', Tour.new(tour_data))
   end
  end
end
