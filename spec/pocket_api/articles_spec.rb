require 'spec_helper'

describe "Pocket API" do
    before do
        @user_articles = 
            {"616917461"=> {
                "item_id"=>"616917461",
                "given_url"=>"http://hazard.typepad.com/hazard-lights/2014/05/in-my-ifiwereafounder-tweets-i-had-a-few-comments-related-to-hiring-high-performers-and-team-building-not-only-for-finding.html",
                "favorite"=>"0",
                "status"=>"0",
                "time_added"=>"1400350818",
                "time_updated"=>"1400350823",
                "time_read"=>"0",
                "time_favorited"=>"0",
                "sort_id"=>0,
                "resolved_title"=>"Leading high performers",
                "resolved_url"=>"http://hazard.typepad.com/hazard-lights/2014/05/in-my-ifiwereafounder-tweets-i-had-a-few-comments-related-to-hiring-high-performers-and-team-building-not-only-for-finding.html",
                "excerpt"=>"In my #ifiwereafounder tweets, I had a few comments related to hiring high performers and team building, not only for finding a co-founder, but also more generally.",
                "is_article"=>"1"},
            "612214888"=>{
                "item_id"=>"612214888",
                "resolved_id"=>"612214888",
                "given_url"=>"http://blog.fogcreek.com/four-million-to-one/",
                "given_title"=>"",
                "favorite"=>"0",
                "status"=>"0",
                "time_added"=>"1400350798",
                "time_updated"=>"1400350804",
                "time_read"=>"0",
                "time_favorited"=>"0",
                "sort_id"=>1,
                "resolved_title"=>"Four Million to One (Or How I Handle Trello Support)",
                "resolved_url"=>"http://blog.fogcreek.com/four-million-to-one/",
                "excerpt"=>"As we pass four million Trello members I thought it would be a good time to share with other small software development teams the fact that providing high quality support doesn’t have to be expensive"
                "is_article"=>"1"},
            "601179303"=>{
                "item_id"=>"601179303",
                "resolved_id"=>"601179303",
                "given_url"=>
                "http://engineering.zenpayroll.com/how-ach-works-a-developer-perspective-part-1/",
                "given_title"=>"",
                "favorite"=>"0",
                "status"=>"0",
                "time_added"=>"1400350785",
                "time_updated"=>"1400350790",
                "time_read"=>"0",
                "time_favorited"=>"0",
                "sort_id"=>2,
                "resolved_title"=>"How ACH works: A developer perspective - Part 1",
                "resolved_url"=>
                "http://engineering.zenpayroll.com/how-ach-works-a-developer-perspective-part-1/",
                "excerpt"=>
                "Note: This is the first post of a 2-part series. Read part 2 here.  The Automatic Clearing House (ACH) network is the primary way money moves electronically through the banking system today.",
                "is_article"=>"1"},
            "597655825"=>{
                "item_id"=>"597655825",
                "resolved_id"=>"597655825",
                "given_url"=>
                "http://ryancarson.com/post/83149243009/is-it-possible-to-have-a-great-product-with-no-managers",
                "given_title"=>"",
                "favorite"=>"0",
                "status"=>"0",
                "time_added"=>"1400350747",
                "time_updated"=>"1400350752",
                "time_read"=>"0",
                "time_favorited"=>"0",
                "sort_id"=>4,
                "resolved_title"=>
                "Is it possible to have a great product with no managers and a work-from-home culture?",
                "resolved_url"=>
                "http://ryancarson.com/post/83149243009/is-it-possible-to-have-a-great-product-with-no-managers",
                "excerpt"=>
                "If you don’t have managers, and the team is distributed around the World, who decides priorities and makes decisions about the product?  My Co-Founder, Alan, and I set our company-wide goals and mis"
                "is_article"=>"1"}
            }
        @subscription_articles
    end

end