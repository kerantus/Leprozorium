require 'date'
require 'time'
date_new_post = Time.now
puts date_new_post


<% @comment.each do |value| %>

    <p><%= value["date_create"] %></p>
    </br>
    <p><%= value["content"] %></p>

    <a href="/details/<%= value["Id"] %>">Подробнее</a>

    </br>
    </br>

<% end %>