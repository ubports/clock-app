/*
 * Copyright (C) 2015 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "statictimezonemodel.h"

StaticTimeZoneModel::StaticTimeZoneModel(QObject *parent) :
    TimeZoneModel(parent)
{
    setlocale(LC_ALL, "");
    bindtextdomain(GETTEXT_PACKAGE, GETTEXT_LOCALEDIR);
    bind_textdomain_codeset(GETTEXT_PACKAGE, "UTF-8");

    // Load default city list into model when object is initiated
    loadDefaultCityList();
}

void StaticTimeZoneModel::addCity(const QString &cityId, const QString &cityName, const QString &timezone, const QString &countryName) {
    CityData cityData;
    cityData.cityId = cityId;
    cityData.cityName = cityName;
    cityData.countryName = countryName;
    cityData.timeZone = QTimeZone(timezone.toLatin1());
    m_citiesData.append(cityData);
}

void StaticTimeZoneModel::loadDefaultCityList()
{
    // Let QML know model is being reset and rebuilt
    beginResetModel();

    m_citiesData.clear();

    addCity("Abidjan", _("Abidjan"), "Africa/Abidjan", _("Ivory Coast"));
    addCity("Accra", _("Accra"), "Africa/Accra", _("Ghana"));
    addCity("Addis Ababa", _("Addis Ababa"), "Africa/Addis_Ababa", _("Ethiopia"));
    addCity("Adelaide", _("Adelaide"), "Australia/Adelaide", _("Australia"));
    addCity("Albuquerque", _("Albuquerque"), "America/Denver", _("United States"));
    addCity("Algiers", _("Algiers"), "Africa/Algiers", _("Algeria"));
    addCity("Almaty", _("Almaty"), "Asia/Almaty", _("Kazakhstan"));
    addCity("Amman", _("Amman"), "Asia/Amman", _("Jordan"));
    addCity("Amsterdam", _("Amsterdam"), "Europe/Amsterdam", _("Netherlands"));
    addCity("Anadyr", _("Anadyr"), "Asia/Anadyr", _("Russia"));
    addCity("Anchorage", _("Anchorage"), "America/Anchorage", _("United States"));
    addCity("Andorra", _("Andorra"), "Europe/Andorra", _("Andorra"));
    addCity("Ankara", _("Ankara"), "Europe/Istanbul", _("Turkey"));
    addCity("Ann Arbor", _("Ann Arbor"), "America/Detroit", _("United States"));
    addCity("Antananarivo", _("Antananarivo"), "Indian/Antananarivo", _("Madagascar"));
    addCity("Aqtau", _("Aqtau"), "Asia/Aqtau", _("Kazakhstan"));
    addCity("Aruba", _("Aruba"), "America/Aruba", _("Aruba"));
    addCity("Asunción", _("Asunción"), "America/Asuncion", _("Paraguay"));
    addCity("Athens", _("Athens"), "Europe/Athens", _("Greece"));
    addCity("Atlanta", _("Atlanta"), "America/New_York", _("United States"));
    addCity("Auckland", _("Auckland"), "Pacific/Auckland", _("New Zealand"));
    addCity("Austin", _("Austin"), "America/Chicago", _("United States"));

    addCity("Baghdad", _("Baghdad"), "Asia/Baghdad", _("Iraq"));
    addCity("Bahrain", _("Bahrain"), "Asia/Bahrain", _("Bahrain"));
    addCity("Baku", _("Baku"), "Asia/Baku", _("Azerbaijan"));
    addCity("Baltimore", _("Baltimore"), "America/New_York", _("United States"));
    addCity("Bangalore", _("Bangalore"), "Asia/Kolkata", _("India"));
    addCity("Bangkok", _("Bangkok"), "Asia/Bangkok", _("Thailand"));
    addCity("Barbados", _("Barbados"), "America/Barbados", _("Barbados"));
    addCity("Barcelona", _("Barcelona"), "Europe/Madrid", _("Spain"));
    addCity("Beijing", _("Beijing"), "Asia/Shanghai", _("China"));
    addCity("Beirut", _("Beirut"), "Asia/Beirut", _("Lebanon"));
    addCity("Belfast", _("Belfast"), "Europe/Belfast", _("United Kingdom"));
    addCity("Belgrade", _("Belgrade"), "Europe/Belgrade", _("Serbia"));
    addCity("Belize", _("Belize"), "America/Belize", _("Belize"));
    addCity("Belo Horizonte", _("Belo Horizonte"), "America/Sao_Paulo", _("Brazil"));
    addCity("Berlin", _("Berlin"), "Europe/Berlin", _("Germany"));
    addCity("Bermuda", _("Bermuda"), "Atlantic/Bermuda", _("Bermuda"));
    addCity("Beulah", _("Beulah"), "America/North_Dakota/Beulah", _("United States"));
    addCity("Black Rock City", _("Black Rock City"), "America/Chicago", _("United States"));
    addCity("Blantyre", _("Blantyre"), "Africa/Blantyre", _("Malawi"));
    addCity("Bogotá", _("Bogotá"), "America/Bogota", _("Colombia"));
    addCity("Boston", _("Boston"), "America/New_York", _("United States"));
    addCity("Boulder", _("Boulder"), "America/Denver", _("United States"));
    addCity("Brasília", _("Brasília"), "America/Sao_Paulo", _("Brazil"));
    addCity("Bratislava", _("Bratislava"), "Europe/Bratislava", _("Slovakia"));
    addCity("Brazzaville", _("Brazzaville"), "Africa/Brazzaville", _("Republic of the Congo"));
    addCity("Brisbane", _("Brisbane"), "Australia/Brisbane", _("Australia"));
    addCity("Brussels", _("Brussels"), "Europe/Brussels", _("Belgium"));
    addCity("Bucharest", _("Bucharest"), "Europe/Bucharest", _("Romania"));
    addCity("Budapest", _("Budapest"), "Europe/Budapest", _("Hungary"));
    addCity("Buenos Aires", _("Buenos Aires"), "America/Argentina/Buenos_Aires", _("Argentina"));

    addCity("Cairo", _("Cairo"), "Africa/Cairo", _("Egypt"));
    addCity("Calcutta", _("Calcutta"), "Asia/Calcutta", _("India"));
    addCity("Calgary", _("Calgary"), "America/Edmonton", _("Canada"));
    addCity("Cambridge", _("Cambridge"), "Europe/London", _("United Kingdom"));
    addCity("Canary", _("Canary"), "Atlantic/Canary", _("Australia"));
    addCity("Canberra", _("Canberra"), "Australia/Canberra", _("Australia"));
    addCity("Cancún", _("Cancún"), "America/Cancun", _("Mexico"));
    addCity("Cape Town", _("Cape Town"), "Africa/Johannesburg", _("South Africa"));
    addCity("Caracas", _("Caracas"), "America/Caracas", _("Venezuela"));
    addCity("Casablanca", _("Casablanca"), "Africa/Casablanca", _("Morocco"));
    addCity("Cayman Palms", _("Cayman Palms"), "America/Cayman", _("Cayman Islands"));
    addCity("Chicago", _("Chicago"), "America/Chicago", _("United States"));
    addCity("Chihuahua", _("Chihuahua"), "America/Chihuahua", _("Mexico"));
    addCity("Chişinău", _("Chişinău"), "Europe/Chisinau", _("Moldova"));
    addCity("Cincinnati", _("Cincinnati"), "America/New_York", _("United States"));
    addCity("Cleveland", _("Cleveland"), "America/New_York", _("United States"));
    addCity("Colombo", _("Colombo"), "Asia/Colombo", _("Sri Lanka"));
    addCity("Columbus", _("Columbus"), "America/New_York", _("United States"));
    addCity("Conakry", _("Conakry"), "Africa/Conakry", _("Guinea"));
    addCity("Copenhagen", _("Copenhagen"), "Europe/Copenhagen", _("Denmark"));
    addCity("Costa Rica", _("Costa Rica"), "America/Costa_Rica", _("Costa Rica"));
    addCity("Curaçao", _("Curaçao"), "America/Curacao", _("Curacao"));

    addCity("Dakar", _("Dakar"), "Africa/Dakar", _("Senegal"));
    addCity("Dallas", _("Dallas"), "America/Chicago", _("United States"));
    addCity("Damascus", _("Damascus"), "Asia/Damascus", _("Syria"));
    addCity("Dar es Salaam", _("Dar es Salaam"), "Africa/Dar_es_Salaam", _("Tanzania"));
    addCity("Darwin", _("Darwin"), "Australia/Darwin", _("Australia"));
    addCity("Dawson Creek", _("Dawson Creek"), "America/Dawson_Creek", _("Canada"));
    addCity("Delhi", _("Delhi"), "Asia/Kolkata", _("India"));
    addCity("Denver", _("Denver"), "America/Denver", _("United States"));
    addCity("Detroit", _("Detroit"), "America/Detroit", _("United States"));
    addCity("Dhaka", _("Dhaka"), "Asia/Dhaka", _("Bangladesh"));
    addCity("Djibouti", _("Djibouti"), "Africa/Djibouti", _("Djibouti"));
    addCity("Doha", _("Doha"), "Asia/Qatar", _("Qatar"));
    addCity("Dominica", _("Dominica"), "America/Dominica", _("Dominica"));
    addCity("Dubai", _("Dubai"), "Asia/Dubai", _("United Arab Emirates"));
    addCity("Dublin", _("Dublin"), "Europe/Dublin", _("Ireland"));

    addCity("Easter Island", _("Easter Island"), "Pacific/Easter", _("Chile"));
    addCity("Edmonton", _("Edmonton"), "America/Edmonton", _("Canada"));
    addCity("El Salvador", _("El Salvador"), "America/El_Salvador", _("El Salvador"));

    addCity("Fiji", _("Fiji"), "Pacific/Fiji", _("Fiji"));
    addCity("Fortaleza", _("Fortaleza"), "America/Fortaleza", _("Brazil"));
    addCity("Frankfurt", _("Frankfurt"), "Europe/Berlin", _("Germany"));
    addCity("Freetown", _("Freetown"), "Africa/Freetown", _("Sierra Leone"));

    addCity("Gaborone", _("Gaborone"), "Africa/Gaborone", _("Botswana"));
    addCity("Gaza", _("Gaza"), "Asia/Gaza", _("Palestine"));
    addCity("Gibraltar", _("Gibraltar"), "Europe/Gibraltar", _("Gibraltar"));
    addCity("Grand Turk", _("Grand Turk"), "America/Grand_Turk", _("Turks and Caicos Islands"));
    addCity("Grenada", _("Grenada"), "America/Grenada", _("Grenada"));
    addCity("Guam", _("Guam"), "Pacific/Guam", _("Guam"));
    addCity("Guangzhou", _("Guangzhou"), "Asia/Shanghai", _("China"));
    addCity("Guatemala", _("Guatemala"), "America/Guatemala", _("Guatemala"));
    addCity("Gurgaon", _("Gurgaon"), "Asia/Kolkata", _("India"));
    addCity("Guyana", _("Guyana"), "America/Guyana", _("Guyana"));

    addCity("Haifa", _("Haifa"), "Asia/Jerusalem", _("Israel"));
    addCity("Halifax", _("Halifax"), "America/Halifax", _("Canada"));
    addCity("Hamburg", _("Hamburg"), "Europe/Berlin", _("Germany"));
    addCity("Hanoi", _("Hanoi"), "Asia/Ho_Chi_Minh", _("Vietnam"));
    addCity("Harare", _("Harare"), "Africa/Harare", _("Zimbabwe"));
    addCity("Havana", _("Havana"), "America/Havana", _("Cuba"));
    addCity("Hebron", _("Hebron"), "Asia/Hebron", _("Palestine"));
    addCity("Helsinki", _("Helsinki"), "Europe/Helsinki", _("Finland"));
    addCity("Ho Chi Minh City", _("Ho Chi Minh City"), "Asia/Ho_Chi_Minh", _("Vietnam"));
    addCity("Hong Kong", _("Hong Kong"), "Asia/Hong_Kong", _("Hong Kong"));
    addCity("Honolulu", _("Honolulu"), "Pacific/Honolulu", _("United States"));
    addCity("Houston", _("Houston"), "America/Chicago", _("United States"));
    addCity("Hyderabad", _("Hyderabad"), "Asia/Kolkata", _("India"));

    addCity("Indianapolis", _("Indianapolis"), "America/Indiana/Indianapolis", _("United States"));
    addCity("Islamabad", _("Islamabad"), "Asia/Karachi", _("Pakistan"));
    addCity("Isle of Man", _("Isle of Man"), "Europe/Isle_of_Man", _("Isle of Man"));
    addCity("Istanbul", _("Istanbul"), "Europe/Istanbul", _("Turkey"));

    addCity("Jacksonville", _("Jacksonville"), "America/New_York", _("United States"));
    addCity("Jakarta", _("Jakarta"), "Asia/Jakarta", _("Indonesia"));
    addCity("Jerusalem", _("Jerusalem"), "Asia/Jerusalem", _("Israel"));
    addCity("Johannesburg", _("Johannesburg"), "Africa/Johannesburg", _("South Africa"));

    addCity("Kabul", _("Kabul"), "Asia/Kabul", _("Afghanistan"));
    addCity("Kampala", _("Kampala"), "Africa/Kampala", _("Uganda"));
    addCity("Karachi", _("Karachi"), "Asia/Karachi", _("Pakistan"));
    addCity("Khartoum", _("Khartoum"), "Africa/Khartoum", _("Sudan"));
    addCity("Kiev", _("Kiev"), "Europe/Kiev", _("Ukraine"));
    addCity("Kigali", _("Kigali"), "Africa/Kigali", _("Rwanda"));
    addCity("Kingston", _("Kingston"), "America/Toronto", _("Canada"));
    addCity("Kinshasa", _("Kinshasa"), "Africa/Kinshasa", _("Democratic Republic of the Congo"));
    addCity("Kiritimati", _("Kiritimati"), "Pacific/Kiritimati", _("Kiribati"));
    addCity("Kirkland", _("Kirkland"), "America/Montreal", _("Canada"));
    addCity("Knox", _("Knox"), "Australia/Melbourne", _("Australia"));
    addCity("Knoxville", _("Knoxville"), "America/New_York", _("United States"));
    addCity("Kraków", _("Kraków"), "Europe/Warsaw", _("Poland"));
    addCity("Kuala Lumpur", _("Kuala Lumpur"), "Asia/Kuala_Lumpur", _("Malaysia"));
    addCity("Kuwait Cit", _("Kuwait City"), "Asia/Kuwait", _("Kuwait"));
    addCity("Kyiv", _("Kyiv"), "Europe/Kiev", _("Ukraine"));

    addCity("Lagos", _("Lagos"), "Africa/Lagos", _("Nigeria"));
    addCity("Lahore", _("Lahore"), "Asia/Karachi", _("Pakistan"));
    addCity("Las Vegas", _("Las Vegas"), "America/Los_Angeles", _("United States"));
    addCity("Lima", _("Lima"), "America/Lima", _("Peru"));
    addCity("Lisbon", _("Lisbon"), "Europe/Lisbon", _("Portugal"));
    addCity("London", _("London"), "Europe/London", _("United Kingdom"));
    addCity("Longyearbyen", _("Longyearbyen"), "Arctic/Longyearbyen", _("Svalbard and Jan Mayen"));
    addCity("Los Angeles", _("Los Angeles"), "America/Los_Angeles", _("United States"));
    addCity("Louisville", _("Louisville"), "America/Kentucky/Louisville", _("United States"));
    addCity("Luxembourg", _("Luxembourg"), "Europe/Luxembourg", _("Luxembourg"));

    addCity("Macau", _("Macau"), "Asia/Macau", _("Macao"));
    addCity("Madison", _("Madison"), "America/Chicago", _("United States"));
    addCity("Madrid", _("Madrid"), "Europe/Madrid", _("Spain"));
    addCity("Maldives", _("Maldives"), "Indian/Maldives", _("Maldives"));
    addCity("Malta", _("Malta"), "Europe/Malta", _("Malta"));
    addCity("Managua", _("Managua"), "America/Managua", _("Nicaragua"));
    addCity("Manchester", _("Manchester"), "Europe/London", _("United Kingdom"));
    addCity("Manila", _("Manila"), "Asia/Manila", _("Philippines"));
    addCity("Marengo", _("Marengo"), "America/Indiana/Marengo", _("United States"));
    addCity("Martinique", _("Martinique"), "America/Martinique", _("Canada"));
    addCity("Maseru", _("Maseru"), "Africa/Maseru", _("Lesotho"));
    addCity("Melbourne", _("Melbourne"), "Australia/Melbourne", _("Australia"));
    addCity("Memphis", _("Memphis"), "America/Chicago", _("United States"));
    addCity("Mendoza", _("Mendoza"), "America/Argentina/Mendoza", _("Argentina"));
    addCity("Metlakatla", _("Metlakatla"), "America/Metlakatla", _("United States"));
    addCity("Mexico City", _("Mexico City"), "America/Mexico_City", _("Mexico"));
    addCity("Miami", _("Miami"), "America/New_York", _("United States"));
    addCity("Milan", _("Milan"), "Europe/Rome", _("Italy"));
    addCity("Milwaukee", _("Milwaukee"), "America/Chicago", _("United States"));
    addCity("Minneapolis", _("Minneapolis"), "America/Chicago", _("United States"));
    addCity("Minsk", _("Minsk"), "Europe/Minsk", _("Belarus"));
    addCity("Mogadishu", _("Mogadishu"), "Africa/Mogadishu", _("Somalia"));
    addCity("Monrovia", _("Monrovia"), "Africa/Monrovia", _("Liberia"));
    addCity("Monaco", _("Monaco"), "Europe/Monaco", _("Monaco"));
    addCity("Monterrey", _("Monterrey"), "America/Monterrey", _("Mexico"));
    addCity("Montevideo", _("Montevideo"), "America/Montevideo", _("Uruguay"));
    addCity("Montreal", _("Montreal"), "America/Montreal", _("Canada"));
    addCity("Moscow", _("Moscow"), "Europe/Moscow", _("Russia"));
    addCity("Mountain View", _("Mountain View"), "America/Los_Angeles", _("United States"));
    addCity("Mumbai", _("Mumbai"), "Asia/Kolkata", _("India"));
    addCity("Munich", _("Munich"), "Europe/Berlin", _("Germany"));
    addCity("Muscat", _("Muscat"), "Asia/Muscat", _("Oman"));

    addCity("Nairobi", _("Nairobi"), "Africa/Nairobi", _("Kenya"));
    addCity("Nashville", _("Nashville"), "America/Chicago", _("United States"));
    addCity("Nassau", _("Nassau"), "America/Nassau", _("Bahamas"));
    addCity("New Orleans", _("New Orleans"), "America/Chicago", _("United States"));
    addCity("New Salem", _("New Salem"), "America/North_Dakota/New_Salem", _("United States"));
    addCity("New South Wales", _("New South Wales"), "Australia/Sydney", _("Australia"));
    addCity("New York", _("New York"), "America/New_York", _("United States"));
    addCity("Newfoundland", _("Newfoundland"), "America/St_Johns", _("United States"));
    addCity("Nouméa", _("Nouméa"), "Pacific/Noumea", _("New Caledonia"));
    addCity("Nuestra Señora de La Paz", _("Nuestra Señora de La Paz"), "America/Bogota", _("Colombia"));

    addCity("Oklahoma City", _("Oklahoma City"), "America/Chicago", _("United States"));
    addCity("Osaka", _("Osaka"), "Asia/Tokyo", _("Japan"));
    addCity("Oslo", _("Oslo"), "Europe/Oslo", _("Norway"));
    addCity("Ottawa", _("Ottawa"), "America/Toronto", _("Canada"));
    addCity("Oulu", _("Oulu"), "Europe/Helsinki", _("Finland"));

    addCity("Panamá", _("Panamá"), "America/Panama", _("Panama"));
    addCity("Paramaribo", _("Paramaribo"), "America/Paramaribo", _("Suriname"));
    addCity("Paris", _("Paris"), "Europe/Paris", _("France"));
    addCity("Perth", _("Perth"), "Australia/Perth", _("Australia"));
    addCity("Petersburg", _("Petersburg"), "America/Indiana/Petersburg", _("Russia"));
    addCity("Philadelphia", _("Philadelphia"), "America/New_York", _("United States"));
    addCity("Phnom Penh", _("Phnom Penh"), "Asia/Phnom_Penh", _("Cambodia"));
    addCity("Phoenix", _("Phoenix"), "America/Phoenix", _("United States"));
    addCity("Pittsburgh", _("Pittsburgh"), "America/New_York", _("United States"));
    addCity("Port of Spain", _("Port of Spain"), "America/Port_of_Spain", _("Trinidad and Tobago"));
    addCity("Port au Prince", _("Port au Prince"), "America/Port-au-Prince", _("Haiti"));
    addCity("Portland", _("Portland"), "America/Los_Angeles", _("United States"));
    addCity("Prague", _("Prague"), "Europe/Prague", _("Czech"));
    addCity("Pyongyang", _("Pyongyang"), "Asia/Pyongyang", _("North Korea"));

    addCity("Queensland", _("Queensland"), "Australia/Brisbane", _("United States"));
    addCity("Quito", _("Quito"), "America/Guayaquil", _("Ecuador"));

    addCity("Rangoon", _("Rangoon"), "Asia/Rangoon", _("Myanmar"));
    addCity("Reno", _("Reno"), "America/Los_Angeles", _("United States"));
    addCity("Reston", _("Reston"), "America/New_York", _("United States"));
    addCity("Reykjavík", _("Reykjavík"), "Atlantic/Reykjavik", _("Iceland"));
    addCity("Riga", _("Riga"), "Europe/Riga", _("Latvia"));
    addCity("Rio de Janeiro", _("Rio de Janeiro"), "America/Sao_Paulo", _("Brazil"));
    addCity("Riyadh", _("Riyadh"), "Asia/Riyadh", _("Saudi Arabia"));
    addCity("Rome", _("Rome"), "Europe/Rome", _("Italy"));

    addCity("Sacramento", _("Sacramento"), "America/Los_Angeles", _("United States"));
    addCity("Salt Lake City", _("Salt Lake City"), "America/Denver", _("United States"));
    addCity("Samoa", _("Samoa"), "Pacific/Apia", _("Samoa"));
    addCity("San Antonio", _("San Antonio"), "America/Chicago", _("United States"));
    addCity("San Diego", _("San Diego"), "America/Los_Angeles", _("United States"));
    addCity("San Francisco", _("San Francisco"), "America/Costa_Rica", _("United States"));
    addCity("San José", _("San José"), "America/Costa_Rica", _("Costa Rica"));
    addCity("San Juan", _("San Juan"), "America/Puerto_Rico", _("Puerto Rico"));
    addCity("San Marino", _("San Marino"), "Europe/San_Marino", _("San Marino"));
    addCity("San Salvador", _("San Salvador"), "America/El_Salvador", _("El Salvador"));
    addCity("Sanaa", _("Sanaa"), "Asia/Aden", _("Yemen"));
    addCity("Santiago", _("Santiago"), "America/Santiago", _("Chile"));
    addCity("Santo Domingo", _("Santo Domingo"), "America/Santo_Domingo", _("Dominican Republic"));
    addCity("São Paulo", _("São Paulo"), "America/Sao_Paulo", _("Brazil"));
    addCity("São Tomé", _("São Tomé"), "Africa/Sao_Tome", _("São Tomé and Príncipe"));
    addCity("Sarajevo", _("Sarajevo"), "Europe/Sarajevo", _("Bosnia and Herzegovina"));
    addCity("Saskatchewan", _("Saskatchewan"), "America/Regina", _("Canada"));
    addCity("Seattle", _("Seattle"), "America/Los_Angeles", _("United States"));
    addCity("Seoul", _("Seoul"), "Asia/Seoul", _("South Korea"));
    addCity("Shanghai", _("Shanghai"), "Asia/Shanghai", _("China"));
    addCity("Singapore", _("Singapore"), "Asia/Singapore", _("Singapore"));
    addCity("Simferopol", _("Simferopol"), "Europe/Simferopol", _("Ukraine"));
    addCity("Skopje", _("Skopje"), "Europe/Skopje", _("Macedonia"));
    addCity("Sofia", _("Sofia"), "Europe/Sofia", _("Bulgaria"));
    addCity("St.Johns", _("St.Johns"), "America/St_Johns", _("Canada"));
    addCity("St.Kitts", _("St.Kitts"), "America/St_Kitts", _("Saint Kitts and Nevis"));
    addCity("St.Louis", _("St.Louis"), "America/Chicago", _("United States"));
    addCity("Stanley", _("Stanley"), "Atlantic/Stanley", _("Falkland Islands"));
    addCity("Stockholm", _("Stockholm"), "Europe/Stockholm", _("Sweden"));
    addCity("Suva", _("Suva"), "Pacific/Fiji", _("Fiji"));
    addCity("Sydney", _("Sydney"), "Australia/Sydney", _("Australia"));

    addCity("Taipei", _("Taipei"), "Asia/Taipei", _("Taiwan"));
    addCity("Tallinn", _("Tallinn"), "Europe/Tallinn", _("Estonia"));
    addCity("Tehran", _("Tehran"), "Asia/Tehran", _("Iran"));
    addCity("Tokyo", _("Tokyo"), "Asia/Tokyo", _("Japan"));
    addCity("Toronto", _("Toronto"), "America/Toronto", _("Canada"));
    addCity("Tripoli", _("Tripoli"), "Africa/Tripoli", _("Libya"));
    addCity("Tunis", _("Tunis"), "Africa/Tunis", _("Tunisia"));

    addCity("Ulan Bator", _("Ulan Bator"), "Asia/Ulan_Bator", _("Mongolia"));
    addCity("UTC", _("UTC"), "UTC", _("UTC"));

    addCity("Vancouver", _("Vancouver"), "America/Vancouver", _("Canada"));
    addCity("Vatican City", _("Vatican City"), "Europe/Vatican", _("Vatican City"));
    addCity("Vevay", _("Vevay"), "America/Indiana/Vevay", _("United States"));
    addCity("Vienna", _("Vienna"), "Europe/Vienna", _("Austria"));
    addCity("Vilnius", _("Vilnius"), "Europe/Vilnius", _("Lithuania"));
    addCity("Vincennes", _("Vincennes"), "America/Indiana/Vincennes", _("France"));

    addCity("Warsaw", _("Warsaw"), "Europe/Warsaw", _("Poland"));
    addCity("Washington D.C.", _("Washington D.C."), "America/New_York", _("United States"));
    addCity("Winamac", _("Winamac"), "America/Indiana/Winamac", _("United States"));
    addCity("Winnipeg", _("Winnipeg"), "America/Winnipeg", _("Canada"));
    addCity("Wrocław", _("Wrocław"), "Europe/Warsaw", _("Poland"));

    addCity("Zagreb", _("Zagreb"), "Europe/Zagreb", _("Croatia"));
    addCity("Zürich", _("Zürich"), "Europe/Zurich", _("Switzerland"));

    // Let QML know model is reusable again
    endResetModel();
}

TimeZoneModel::CityData StaticTimeZoneModel::getTranslatedCityData(const QString &cityId)
{
   for (QList<TimeZoneModel::CityData>::const_iterator tz_iter = m_citiesData.begin(); tz_iter != m_citiesData.end(); ++tz_iter)
   {
       if (QString::compare(tz_iter->cityId, cityId) == 0)
       {
           return *tz_iter;
       }       
   }

   TimeZoneModel::CityData emptyCityData;
   emptyCityData.cityId = "";
   emptyCityData.cityName = "";
   emptyCityData.countryName = "";
   return emptyCityData;
}

