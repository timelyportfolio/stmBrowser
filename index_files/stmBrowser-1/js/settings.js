var settings = {
	textView:{
		id:'textView',
		filePath:'data/output.csv', 
		customBuild:function() {
			$('#control-container-buttons-zoom')[0].parentNode.appendChild($('#control-container-buttons-zoom')[0])
		},
		charts:['scatterChart', 'textChart'], 
		buildChart:function(view, chart, index) {

			switch(chart) {
				case 'scatterChart':
					view.charts[index] = new ScatterChart(settings.scatterChart)
					break
				case 'textChart':
					view.charts[index] = new TextChart(settings.textChart)
					break
				default:
					break;
			}
		},
		clickEvents: [
			{wrapper:'scatterChart-div', klass:'circle', attribute:'circle-id', setting:'selected'},
		], 
	},
	scatterChart:{
		id:'scatterChart',
		getWidth:function(chart) {return $('#'+chart.settings.container).width()*2/3 - 10}, 
		getMargin:function(chart) { 
			var right = d3.keys(chart.settings.colorLabels).length == 0 | chart.settings.colorVar == 'none' ? 50 : 150
			var bottom = 20
			return {
				top:50, 
				bottom:bottom, 
				right:right, 
				left:80
			}
		}, 
		hasTitle:true, 
		getTitleText:function(chart) {
			return chart.settings.xLabel +  ' v.s. ' + chart.settings.yLabel
		}
	},
	textChart: {
		id:'textChart', 
		getWidth:function(chart) {
			var width  = $('#'+chart.settings.container).width()/3 - 10
			return width
		},
		getPosition:function(chart){return {
			top:0, 
			left:$('#'+chart.settings.container).width()*2/3
		}}, 
		getHeight:function(chart) {
			return $('#' + chart.settings.container).innerHeight() - 70 - $('#bottom').height()
		},

	},
}


