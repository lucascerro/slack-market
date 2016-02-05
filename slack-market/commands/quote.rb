module SlackMarket
  module Commands
    class Quote < SlackRubyBot::Commands::Base
      scan(/(\b[A-Z]{2,}+\b)/) do |client, data, stocks|
        YahooFinance::Client.new.quotes(stocks, [:name, :symbol, :last_trade_price, :change, :change_in_percent]).each do |quote|
          next if quote.name == 'N/A'
          logger.info "#{client.team}, user=#{data.user} - #{quote.name} (#{quote.symbol}): $#{quote.last_trade_price}"
          client.web_client.chat_postMessage(
            channel: data.channel,
            as_user: true,
            attachments: [
              {
                fallback: "#{quote.name} (#{quote.symbol}): $#{quote.last_trade_price}",
                title_link: "http://finance.yahoo.com/q?s=#{quote.symbol}",
                title: "#{quote.name} (#{quote.symbol})",
                text: "$#{quote.last_trade_price} (#{quote.change_in_percent})",
                color: quote.change.to_f > 0 ? '#00FF00' : '#FF0000'
              }
            ]
          )
        end
      end
    end
  end
end
