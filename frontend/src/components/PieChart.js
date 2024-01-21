import React from 'react';
import {
    Chart as ChartJS, registerables, CategoryScale, LinearScale, Title, Tooltip, Legend,
} from 'chart.js';
import { Pie } from 'react-chartjs-2';

ChartJS.register(...registerables);

const PieChart = ({ title, data }) => {
    const chartData = {
        labels: Object.keys(data),
        datasets: [{
            label: `# of ${title.toLowerCase()}`,
            data: Object.values(data),
            backgroundColor: ['rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)', 'rgba(153, 102, 255, 0.2)', 'rgba(255, 159, 64, 0.2)'],
            borderColor: ['rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)', 'rgba(255, 159, 64, 1)'],
            borderWidth: 1,
        }],
    };

    const options = {
        plugins: {
            legend: {
                display: true,
                position: 'right',
            },
            title: {
                display: true,
                text: title,
                font: {
                    size: 20,
                }
            }
        }
    };

    return (
        <div className="chart-pie">
            <Pie data={chartData} options={options} />
        </div>
    );
};

export default PieChart;