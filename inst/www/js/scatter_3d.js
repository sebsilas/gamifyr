
var data;

function plot_3d(x_coords, y_coords, z_coords) {
  console.log('plot_3d!');

  var population = {
      x: x_coords,
      y: y_coords,
      z: z_coords,
      name: "Everyone Else",
      mode: 'markers',
      marker: {
        size: 6,
        color: 'rgb(177, 223, 240)'
      },
      type: 'scatter3d'
  };

  var highlighted = {
      x: [50],
      y: [50],
      z: [50],
      mode: 'markers',
      name: "Your Score!",
      marker: {
        size: 12,
        color: 'rgb(255, 142, 66)'
      },
      type: 'scatter3d'
    };


  var layout = {
    name: 'Your Musical Genius Score!',
    height: 900,
    width: 900,
    scene: {
  		xaxis:{ title: 'Melodic Discrimination' },
  		yaxis:{ title: 'Beat Alignment' },
  		zaxis:{ title: 'Mistuning'  }
		}
  };

  data = [population, highlighted];

  console.log(data);
  console.log(layout);


  if(is_graph_defined()) {
    Plotly.plot('graph', data, layout);
  }

}

function is_graph_defined() {
  var graph = document.getElementById("graph");
  typeof graph !== null;
}

function update_plot_3d(x_coords, y_coords, z_coords) {

  console.log('update plot');

  var population = {
      x: x_coords,
      y: y_coords,
      z: z_coords,
      name: "Everyone Else",
      mode: 'markers',
      marker: {
        size: 6,
        color: 'rgb(177, 223, 240)'
      },
      type: 'scatter3d'
  };

  console.log("Note, this doesn't show the real score!!!");

  var highlighted = {
      x: [50],
      y: [50],
      z: [50],
      mode: 'markers',
      name: "Your Score!",
      marker: {
        size: 12,
        color: 'rgb(255, 142, 66)'
      },
      type: 'scatter3d'
    };


  var layout = {
    name: 'Your Musical Genius Score!',
    scene: {
  		xaxis:{ title: 'Melodic Discrimination' },
  		yaxis:{ title: 'Beat Alignment' },
  		zaxis:{ title: 'Mistuning' }
		}
  };

  var data = [population, highlighted];

  if(is_graph_defined()) {
    Plotly.newPlot('graph', data, layout);
  }

}


