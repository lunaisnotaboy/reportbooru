module Reports
  class MemberUploads < Uploads
    def version
      1
    end

    def html_template
      return <<-EOS
%html
  %head
    %title Member Upload Report
    %meta{:name => "viewport", :content => "width=device-width, initial-scale=1"}
    %script{:src => "/reports/assets/jquery-3.1.1.slim.min.js"}
    %script{:src => "/reports/assets/jquery.tablesorter.min.js"}
    %link{:rel => "stylesheet", :href => "/reports/assets/pure.css"}
    :javascript
      $(function() {
        $("#report").tablesorter();
      });
  %body
    %table{:id => "report", :class => "pure-table pure-table-bordered pure-table-striped"}
      %caption Limited uploaders over past thirty days (minimum uploads is #{min_uploads})
      %thead
        %tr
          %th User
          %th Lvl
          %th Tot
          %th Byp
          %th Del
          %th Del Conf
          %th Unq Flag
          %th Src
          %th S
          %th Q
          %th E
          %th Gen
          %th Char
          %th Copy
          %th Art
          %th Med Score
          %th Neg Conf
          %th Unq Downvote
      %tbody
        - data.each do |datum|
          %tr
            %td
              %a{:class => "user-\#{datum[:level]}", :href => "https://danbooru.donmai.us/users/\#{datum[:id]}"}= datum[:name]
            %td= datum[:level_string]
            %td= datum[:total]
            %td= datum[:queue_bypass]
            %td= datum[:deleted]
            %td= datum[:del_conf]
            %td= datum[:uniq_flaggers]
            %td= datum[:source]
            %td= datum[:safe]
            %td= datum[:questionable]
            %td= datum[:explicit]
            %td= datum[:general]
            %td= datum[:character]
            %td= datum[:copyright]
            %td= datum[:artist]
            %td= datum[:med_score]
            %td= datum[:neg_conf]
            %td= datum[:uniq_downvoters]
    %p= "Since #{date_window.utc} to #{Time.now.utc}"
EOS
    end

    def candidates
      DanbooruRo::User.joins("join posts on posts.uploader_id = users.id").where("posts.created_at >= ? and users.bit_prefs & ? = 0", date_window, 1 << 14).group("users.id").having("count(*) > ?", min_uploads).pluck("distinct(users.id)")
    end

    def report_name
      "member_uploads"
    end

    def min_uploads
      100
    end
  end
end
