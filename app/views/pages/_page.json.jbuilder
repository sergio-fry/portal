json.extract! page, :id, :title, :content, :created_at, :updated_at
json.url page_url(page, format: :json)
json.content page.content.to_s
