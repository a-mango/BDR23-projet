import React from 'react';
import {
    Chart as ChartJS, registerables, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend,
} from 'chart.js';
import { Bar } from 'react-chartjs-2';

ChartJS.register(...registerables);

const BarChart = ({ title, data }) => {
    const chartData = {
        labels: Object.keys(data),
        datasets: [{
            label: '# of Votes',
            data: Object.values(data),
            backgroundColor: ['rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)', 'rgba(153, 102, 255, 0.2)', 'rgba(255, 159, 64, 0.2)'],
            borderColor: ['rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)', 'rgba(255, 159, 64, 1)'],
            borderWidth: 1,
        }],
    };

    const options = {
        scales: {
            y: {
                beginAtZero: true,
            },
        },
        plugins: {
            title: {
                display: true,
                text: title
            }
        }
    };

    return (
        <div className="chart-bar">
            <Bar data={chartData} options={options} />
        </div>
    );
};

export default BarChart;