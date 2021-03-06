module RailsHighchartsHelper
  # ActiveSupport::JSON.unquote_hash_key_identifiers = false
  def high_chart(placeholder, object  , &block)
    object.html_options.merge!({:id=>placeholder})
    object.options[:chart][:renderTo] = placeholder
    high_graph(placeholder, object, &block).concat(content_tag("div", "", object.html_options))
  end

  def high_graph(placeholder, object, &block)
    graph =<<-EOJS
    <script type="text/javascript">
    jQuery(function() {
      // 1. Define JSON options
      var options = { chart:       #{object.options[:chart].to_json},
                      title:       #{object.options[:title].to_json},
                      legend:      #{object.options[:legend].to_json},
                      xAxis:       #{object.options[:x_axis].to_json},
                      yAxis:       #{object.options[:y_axis].to_json},
                      tooltip:     #{object.options[:tooltip].to_json},
                      credits:     #{object.options[:credits].to_json},
                      plotOptions: #{object.options[:plot_options].to_json},
                      series:      #{object.data.to_json},
                      subtitle:    #{object.options[:subtitle].to_json}
      };

      // 2. Add callbacks (non-JSON compliant)
      #{capture(&block) if block_given?}
      // 3. Build the chart
      var chart = new Highcharts.Chart(options);
      });
      </script>
      EOJS
      if defined?(raw) &&  Rails.version.to_i >= 3
        return raw(graph) 
      else
        return graph unless block_given?
        concat graph
      end
    end

  end #RailsHighchartsHelper