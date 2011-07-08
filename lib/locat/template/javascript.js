
function create_chart(chart_id, chart_table, chart_type){
  options = chart_options(chart_id, chart_table, chart_type);
  return(new Highcharts.Chart(options));
};

function chart_options(chart_id, chart_table, chart_type){
  options = {
      chart: {
          renderTo: 'container-' + chart_id,
          type: chart_type
      },
      title: {
          text: chart_id
      },
      tooltip: {
          enable: true 
      },
      xAxis: {
          categories: []
      },
      yAxis: {
          title: {
              text: '' //chart_id
          }
      },
      series: []
  };

  $.each(chart_table, function(lineNo, line) {
      // header line containes categories
      if (lineNo == 0) {
          $.each(line, function(itemNo, item) {
              if (itemNo > 0) options.xAxis.categories.push(item);
          });
      }
      // the rest of the lines contain data with their name in the first position
      else {
          var series = {
              data: []
          };
          $.each(line, function(itemNo, item) {
              if (itemNo == 0) {
                  series.name = item;
                  //series.type = chart_type;
              } else {
                  series.data.push(parseFloat(item));
              }
          });
          options.series.push(series);
      }
  });
  return(options);
};

