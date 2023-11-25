// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const defaultTheme = require('tailwindcss/defaultTheme')

const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/platform_web.ex",
    "../lib/platform_web/**/*.*ex"
  ],
  darkMode: "class",
  theme: {
    boxShadow: {
      md: "0 4px 7px -1px rgba(0,0,0,.11),0 2px 4px -1px rgba(0,0,0,.07)",
      lg: "0 2px 12px 0 rgba(0,0,0,.16)",
      xl: "0 20px 27px 0 rgba(0,0,0,0.05)",
      "2xl": "0 .3125rem .625rem 0 rgba(0,0,0,.12)",
    },
    fontFamily: {
      sans: ['Inter var', ...defaultTheme.fontFamily.sans],
    },
    extend: {
      borderRadius: ({ theme }) => ({
        ...theme("spacing"),
      }),
      maxWidth: ({ theme, breakpoints }) => ({
        ...theme("spacing"),
      }),
      minHeight: ({ theme }) => ({
        ...theme("spacing"),
      }),
    }
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(({matchComponents, theme}) => {
      let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5")
          }
        }
      }, {values})
    }),
    plugin(({ addBase, addUtilities }) => {
      addUtilities({
        ".transform-dropdown": {
          transform: "perspective(999px) rotateX(-10deg) translateZ(0) translate3d(0,37px,0)",
        },
        ".transform-dropdown-show": {
          transform: "perspective(999px) rotateX(0deg) translateZ(0) translate3d(0,37px,5px)",
        },
      });
      addBase({
        a: {
          "letter-spacing": "-0.025rem",
        },

        hr: {
          margin: "1rem 0",
          border: "0",
          opacity: ".25",
        },

        img: {
          maxWidth: "none",
        },

        label: {
          display: "inline-block",
        },

        p: {
          "line-height": "1.625",
          "font-weight": "400",
          "margin-bottom": "1rem",
        },

        small: {
          "font-size": ".875em",
        },

        svg: {
          display: "inline",
        },

        table: {
          "border-collapse": "inherit",
        },

        "h1, h2, h3, h4, h5, h6": {
          "margin-bottom": ".5rem",
          color: "#344767",
        },

        "h1, h2, h3, h4": {
          "letter-spacing": "-0.05rem",
        },

        "h1, h2, h3": {
          "font-weight": "700",
        },
        "h4, h5, h6": {
          "font-weight": "600",
        },

        h1: {
          "font-size": "3rem",
          "line-height": "1.25",
        },
        h2: {
          "font-size": "2.25rem",
          "line-height": "1.3",
        },
        h3: {
          "font-size": "1.875rem",
          "line-height": "1.375",
        },
        h4: {
          "font-size": "1.5rem",
          "line-height": "1.375",
        },
        h5: {
          "font-size": "1.25rem",
          "line-height": "1.375",
        },
        h6: {
          "font-size": "1rem",
          "line-height": "1.625",
        },
      });
    }),
    plugin(({ matchUtilities }) => matchUtilities({
      "bg-gradient": (angle) => ({
        "background-image": `linear-gradient(${angle}, var(--tw-gradient-stops))`,
      }),
    })
    ),
  ]
}
