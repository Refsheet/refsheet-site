class StaticController < ApplicationController
  def show
    self.formats.push :html

    if params.include? :id
      path = params[:id]
    else
      path = request.path.gsub /^\//, ''
    end

    path.downcase!
    partial = "static/#{path}"

    if lookup_context.exists?(path, ['static'])
      html = render_to_string partial, layout: false
      data = { id: path, content: html, title: @meta_tags[:title] }
      render json: data
    else
      render json: { error: 'Page not found' }, status: :not_found
    end
  end
end
