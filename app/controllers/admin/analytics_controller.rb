module Admin
  class AnalyticsController < BaseController
    def index
      @monthly_sales = [
        { month: "Jan", sales: 18500, orders: 142 },
        { month: "Feb", sales: 22300, orders: 168 },
        { month: "Mar", sales: 28900, orders: 215 },
        { month: "Apr", sales: 24500, orders: 189 },
        { month: "May", sales: 31200, orders: 245 },
        { month: "Jun", sales: 27800, orders: 210 },
        { month: "Jul", sales: 35600, orders: 278 },
        { month: "Aug", sales: 32400, orders: 256 },
        { month: "Sep", sales: 29800, orders: 232 },
        { month: "Oct", sales: 38900, orders: 298 },
        { month: "Nov", sales: 42100, orders: 325 },
        { month: "Dec", sales: 48500, orders: 378 },
      ]
      
      @top_categories = [
        { name: "Pumps", revenue: 181250, percentage: 32 },
        { name: "Valves", revenue: 145680, percentage: 26 },
        { name: "Bearings", revenue: 98450, percentage: 17 },
        { name: "Controls", revenue: 67200, percentage: 12 },
        { name: "Cylinders", revenue: 45800, percentage: 8 },
        { name: "Others", revenue: 28620, percentage: 5 },
      ]

      @traffic_sources = [
        { source: "Direct", visitors: 12450, percentage: 35 },
        { source: "Google Search", visitors: 10280, percentage: 29 },
        { source: "Social Media", visitors: 5680, percentage: 16 },
        { source: "Email Campaign", visitors: 4250, percentage: 12 },
        { source: "Referral", visitors: 2840, percentage: 8 },
      ]
    end
  end
end
