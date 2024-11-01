local Widget = require("lapis.html").Widget
local ShowInfo = require("views.widgets.show_info")

return Widget:extend(function(self)
  div({ class = "airing width-100 flex-col-center gap-s" }, function()
    h1("Top 5 Airing " .. self.day)
    form({
      action = self:url_for("airing"),
      ["hx-indicator"] = "#loading",
      class = "flex-center flex-wrap gap-s",
    }, function()
      label({ ["for"] = "date", class = "flex-center gap-xs" }, function()
        text("Date:")
        input({
          name = "date",
          type = "date",
          id = "date",
          class = "input",
          max = os.date("%Y-%m-%d"),
          autocomplete = "off",
          value = self.time,
          required = true,
        })
      end)
      label({ ["for"] = "country", class = "flex-center gap-xs" }, function()
        text("Country:")
        element("select", {
          name = "country",
          id = "country",
          class = "input",
          _ = [[
                on load
                set queries to document.URL.split('?')[1]
                set query to queries.split('&')[1]
                set param to query.split('=')[1]
                for x in <option />  
                  if x.value == param then
                    add @selected to x
                  end
                end
              ]],
        }, function()
          option({ value = "", hidden = true })
          option({ value = "AF" }, "Afghanistan")
          option({ value = "AL" }, "Albania")
          option({ value = "DZ" }, "Algeria")
          option({ value = "AR" }, "Argentina")
          option({ value = "AM" }, "Armenia")
          option({ value = "AU" }, "Australia")
          option({ value = "AT" }, "Austria")
          option({ value = "AZ" }, "Azerbaijan")
          option({ value = "BD" }, "Bangladesh")
          option({ value = "BY" }, "Belarus")
          option({ value = "BE" }, "Belgium")
          option({ value = "BO" }, "Bolivia, Plurinational State of")
          option({ value = "BA" }, "Bosnia and Herzegovina")
          option({ value = "BR" }, "Brazil")
          option({ value = "BG" }, "Bulgaria")
          option({ value = "CA" }, "Canada")
          option({ value = "CL" }, "Chile")
          option({ value = "CN" }, "China")
          option({ value = "CO" }, "Colombia")
          option({ value = "HR" }, "Croatia")
          option({ value = "CY" }, "Cyprus")
          option({ value = "CZ" }, "Czech Republic")
          option({ value = "DK" }, "Denmark")
          option({ value = "EG" }, "Egypt")
          option({ value = "EE" }, "Estonia")
          option({ value = "FO" }, "Faroe Islands")
          option({ value = "FI" }, "Finland")
          option({ value = "FR" }, "France")
          option({ value = "PF" }, "French Polynesia")
          option({ value = "GE" }, "Georgia")
          option({ value = "DE" }, "Germany")
          option({ value = "GR" }, "Greece")
          option({ value = "HK" }, "Hong Kong")
          option({ value = "HU" }, "Hungary")
          option({ value = "IS" }, "Iceland")
          option({ value = "IN" }, "India")
          option({ value = "ID" }, "Indonesia")
          option({ value = "IR" }, "Iran, Islamic Republic of")
          option({ value = "IQ" }, "Iraq")
          option({ value = "IE" }, "Ireland")
          option({ value = "IL" }, "Israel")
          option({ value = "IT" }, "Italy")
          option({ value = "JP" }, "Japan")
          option({ value = "KZ" }, "Kazakhstan")
          option({ value = "KP" }, "Korea, Democratic People's Republic of")
          option({ value = "KR" }, "Korea, Republic of")
          option({ value = "LV" }, "Latvia")
          option({ value = "LB" }, "Lebanon")
          option({ value = "LT" }, "Lithuania")
          option({ value = "LU" }, "Luxembourg")
          option({ value = "MY" }, "Malaysia")
          option({ value = "MV" }, "Maldives")
          option({ value = "MX" }, "Mexico")
          option({ value = "MD" }, "Moldova, Republic of")
          option({ value = "MN" }, "Mongolia")
          option({ value = "NL" }, "Netherlands")
          option({ value = "NZ" }, "New Zealand")
          option({ value = "NG" }, "Nigeria")
          option({ value = "NO" }, "Norway")
          option({ value = "PK" }, "Pakistan")
          option({ value = "PE" }, "Peru")
          option({ value = "PH" }, "Philippines")
          option({ value = "PL" }, "Poland")
          option({ value = "PT" }, "Portugal")
          option({ value = "PR" }, "Puerto Rico")
          option({ value = "QA" }, "Qatar")
          option({ value = "RO" }, "Romania")
          option({ value = "RU" }, "Russian Federation")
          option({ value = "SA" }, "Saudi Arabia")
          option({ value = "RS" }, "Serbia")
          option({ value = "SG" }, "Singapore")
          option({ value = "SK" }, "Slovakia")
          option({ value = "SI" }, "Slovenia")
          option({ value = "ZA" }, "South Africa")
          option({ value = "ES" }, "Spain")
          option({ value = "LK" }, "Sri Lanka")
          option({ value = "SE" }, "Sweden")
          option({ value = "CH" }, "Switzerland")
          option({ value = "TW" }, "Taiwan, Province of China")
          option({ value = "TH" }, "Thailand")
          option({ value = "TT" }, "Trinidad and Tobago")
          option({ value = "TN" }, "Tunisia")
          option({ value = "TR" }, "Turkey")
          option({ value = "UA" }, "Ukraine")
          option({ value = "AE" }, "United Arab Emirates")
          option({ value = "GB" }, "United Kingdom")
          option({ value = "US" }, "United States")
          option({ value = "UZ" }, "Uzbekistan")
          option({ value = "VU" }, "Vanuatu")
          option({ value = "VE" }, "Venezuela, Bolivarian Republic of")
          option({ value = "VN" }, "Viet Nam")
        end)
      end)
      button({ class = "input btn" }, "Sort")
    end)
    if type(self.shows) == "table" and next(self.shows) ~= nil then
      div({ class = "popular-shows flex-col-center gap-m" }, function()
        for key in pairs(self.shows) do
          local show = self.shows[key]
          widget(ShowInfo({ show = show, reroute_url = self.req.parsed_url.path }))
        end
      end)
    else
      h2("Nothing to show")
    end
  end)
end)
