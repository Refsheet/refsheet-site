class Admin::DashboardController < AdminController
  def show
    @chart_data = [
        { name: 'Users', data: report_group(User).count, color: '#1F94EE' },
        { name: 'Characters', data: report_group(Character).count, color: '#2BBBAD' },
        { name: 'Images', data: report_group(Image).count, color: '#364755' },
        { name: 'Feedbacks', data: report_group(Feedback).count, color: '#C36F5E' },
        { name: 'Pledges', data: report_group(Patreon::Pledge).count, color: '#EE251F' },
    ]
  end
end
