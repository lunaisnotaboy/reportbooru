=begin
from brokeneagle98:

The following is disregarded if there is a corresponding artist version (See Artist above for implementation details)
Total: total versions/user
Creates: no prior version
Title: title changed
Other Name: other names changed
Body Edits: body changed
Other: no changes, i.e. none of the conditions above are true
=end

module Reports
	class WikiPages < Base
		def version
			1
		end

    def report_name
      "wiki_pages"
    end

    def sort_key
      :total
    end

    def min_changes
			100
		end
		
    def html_template
      return <<-EOS
%html
  %head
    %title Wiki Report
    %style
      :css
        #{pure_css_tables}
    %meta{:name => "viewport", :content => "width=device-width, initial-scale=1"}
  %body
    %table{:class => "pure-table pure-table-bordered pure-table-striped"}
      %caption Wiki updaters (over past thirty days, minimum changes is #{min_changes})
      %thead
        %tr
          %th User
          %th Total
          %th Create
          %th Title
          %th Oth Name
          %th Body
      %tbody
        - data.each do |datum|
          %tr
            %td
              %a{:href => "https://danbooru.donmai.us/users/\#{datum[:id]}"}= datum[:name]
            %td= datum[:total]
            %td= datum[:creates]
            %td= datum[:titles]
            %td= datum[:others]
            %td= datum[:bodies]
EOS
    end

    def calculate_data(user_id)
      user = DanbooruRo::User.find(user_id)
      tda = date_window.strftime("%F %H:%M")
      client = BigQuery::WikiPageVersion.new
      total = client.count_total(user_id, tda)
      creates = client.count_creates(user_id, tda)
      titles = client.count_title_changes(user_id, tda)
      others = client.count_other_name_changes(user_id, tda)
      bodies = client.count_body_changes(user_id, tda)

      return {
        id: user.id,
        name: user.name,
        total: total,
        creates: creates,
        titles: titles,
        others: others,
        bodies: bodies
      }
    end

		def candidates
			DanbooruRo::WikiPageVersion.where("updated_at > ?", date_window).group("updater_id").having("count(*) > ?", min_changes).pluck("updater_id")
		end
	end
end
