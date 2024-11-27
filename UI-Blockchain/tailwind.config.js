const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['InterVariable', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  content: [
    './index.html',
    './src/**/*.{vue,js,ts,jsx,tsx}', // Include your project's files here
  ],
  plugins: [],
};
