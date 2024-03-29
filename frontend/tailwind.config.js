/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        './src/**/*.{js,jsx,ts,tsx}',
    ], theme: {
        extend: {
            colors: {
                'atomic-tangerine': '#f9dc62',
                'apache': '#5acca0',
                'acoustic-white': '#eeebdf',
                'scarlet': '#f86a6a',
            },
        },
    }, plugins: [
        require('@tailwindcss/forms'),
    ],
};