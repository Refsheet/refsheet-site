class Admin::DashboardController < AdminController
  def show
    @main_chart_data = [
        { name: 'Users', data: report_sum(report_group(User).count), color: '#1F94EE' },
        { name: 'Characters', data: report_sum(report_group(Character).count), color: '#2BBBAD' },
    ]

    @left_chart_data = [
        { name: 'Images', data: report_sum(report_group(Image).count), color: '#364755' },
    ]

    @right_chart_data = [
        { name: 'Feedbacks', data: report_sum(report_group(Feedback).count), color: '#C36F5E' },
        { name: 'Pledges', data: report_sum(report_group(Patreon::Pledge).count), color: '#EE251F' },
    ]
  end
end
