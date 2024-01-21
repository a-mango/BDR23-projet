import React from 'react';
import { Chart as ChartJS, registerables } from 'chart.js';
import { Bar } from 'react-chartjs-2';

ChartJS.register(...registerables);

/**
 * Bar chart component.
 *
 * @param title The title of the chart.
 * @param data The data to display in the chart.
 * @returns {Element} The bar chart.
 */
const BarChart = ({ title, data }) => {
    const chartData = {
        labels: Object.keys(data), datasets: [
            {
                label: `# of ${title.toLowerCase()}`,
                data: Object.values(data),
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)',
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)',
                ],
                borderWidth: 1,
            },
        ],
    };

    const options = {
        scales: {
            y: {
                beginAtZero: true,
            },
        }, plugins: {
            legend: {
                display: false,
            }, title: {
                display: true, text: title, font: {
                    size: 20,
                },
            },
        },
    };

    return (<div className="chart-bar">
            <Bar data={chartData} options={options} />
        </div>);
};

export default BarChart;