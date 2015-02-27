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
    // Load default city list into model when object is initiated
    loadDefaultCityList();
}

void StaticTimeZoneModel::addCity(const QString &city, const QString &timezone, const QString &country) {
    TimeZone tz;
    tz.cityName = city;
    tz.country = country;
    tz.timeZone = QTimeZone(timezone.toLatin1());
    m_timeZones.append(tz);
}

void StaticTimeZoneModel::loadDefaultCityList()
{
    // Let QML know model is being reset and rebuilt
    beginResetModel();

    m_timeZones.clear();

    addCity(_("Abidjan"), "Africa/Abidjan", _("Ivory Coast"));
    addCity(_("Accra"), "Africa/Accra", _("Ghana"));
    addCity(_("Addis Ababa"), "Africa/Addis_Ababa", _("Ethiopia"));
    addCity(_("Adelaide"), "Australia/Adelaide", _("Australia"));
    addCity(_("Albuquerque"), "America/Denver", _("United States"));
    addCity(_("Algiers"), "Africa/Algiers", _("Algeria"));
    addCity(_("Almaty"), "Asia/Almaty", _("Kazakhstan"));
    addCity(_("Amman"), "Asia/Amman", _("Jordan"));
    addCity(_("Amsterdam"), "Europe/Amsterdam", _("Netherlands"));
    addCity(_("Anadyr"), "Asia/Anadyr", _("Russia"));
    addCity(_("Anchorage"), "America/Anchorage", _("United States"));
    addCity(_("Andorra"), "Europe/Andorra", _("Andorra"));
    addCity(_("Ankara"), "Europe/Istanbul", _("Turkey"));
    addCity(_("Ann Arbor"), "America/Detroit", _("United States"));
    addCity(_("Antananarivo"), "Indian/Antananarivo", _("Madagascar"));
    addCity(_("Aqtau"), "Asia/Aqtau", _("Kazakhstan"));
    addCity(_("Aruba"), "America/Aruba", _("Aruba"));
    addCity(_("Asunción"), "America/Asuncion", _("Paraguay"));
    addCity(_("Athens"), "Europe/Athens", _("Greece"));
    addCity(_("Atlanta"), "America/New_York", _("United States"));
    addCity(_("Auckland"), "Pacific/Auckland", _("New Zealand"));
    addCity(_("Austin"), "America/Chicago", _("United States"));

    addCity(_("Baghdad"), "Asia/Baghdad", _("Iraq"));
    addCity(_("Bahrain"), "Asia/Bahrain", _("Bahrain"));
    addCity(_("Baku"), "Asia/Baku", _("Azerbaijan"));
    addCity(_("Baltimore"), "America/New_York", _("United States"));
    addCity(_("Bangalore"), "Asia/Kolkata", _("India"));
    addCity(_("Bangkok"), "Asia/Bangkok", _("Thailand"));
    addCity(_("Barbados"), "America/Barbados", _("Barbados"));
    addCity(_("Barcelona"), "Europe/Madrid", _("Spain"));
    addCity(_("Beijing"), "Asia/Shanghai", _("China"));
    addCity(_("Beirut"), "Asia/Beirut", _("Lebanon"));
    addCity(_("Belfast"), "Europe/Belfast", _("United Kingdom"));
    addCity(_("Belgrade"), "Europe/Belgrade", _("Serbia"));
    addCity(_("Belize"), "America/Belize", _("Belize"));
    addCity(_("Belo Horizonte"), "America/Sao_Paulo", _("Brazil"));
    addCity(_("Berlin"), "Europe/Berlin", _("Germany"));
    addCity(_("Bermuda"), "Atlantic/Bermuda", _("Bermuda"));
    addCity(_("Beulah"), "America/North_Dakota/Beulah", _("United States"));
    addCity(_("Black Rock City"), "America/Chicago", _("United States"));
    addCity(_("Blantyre"), "Africa/Blantyre", _("Malawi"));
    addCity(_("Bogotá"), "America/Bogota", _("Colombia"));
    addCity(_("Boston"), "America/New_York", _("United States"));
    addCity(_("Boulder"), "America/Denver", _("United States"));
    addCity(_("Brasília"), "America/Sao_Paulo", _("Brazil"));
    addCity(_("Bratislava"), "Europe/Bratislava", _("Slovakia"));
    addCity(_("Brazzaville"), "Africa/Brazzaville", _("Republic of the Congo"));
    addCity(_("Brisbane"), "Australia/Brisbane", _("Australia"));
    addCity(_("Brussels"), "Europe/Brussels", _("Belgium"));
    addCity(_("Bucharest"), "Europe/Bucharest", _("Romania"));
    addCity(_("Budapest"), "Europe/Budapest", _("Hungary"));
    addCity(_("Buenos Aires"), "America/Argentina/Buenos_Aires", _("Argentina"));

    addCity(_("Cairo"), "Africa/Cairo", _("Egypt"));
    addCity(_("Calcutta"), "Asia/Calcutta", _("India"));
    addCity(_("Calgary"), "America/Edmonton", _("Canada"));
    addCity(_("Cambridge"), "Europe/London", _("United Kingdom"));
    addCity(_("Canary"), "Atlantic/Canary", _("Australia"));
    addCity(_("Canberra"), "Australia/Canberra", _("Australia"));
    addCity(_("Cancún"), "America/Cancun", _("Mexico"));
    addCity(_("Cape Town"), "Africa/Johannesburg", _("South Africa"));
    addCity(_("Caracas"), "America/Caracas", _("Venezuela"));
    addCity(_("Casablanca"), "Africa/Casablanca", _("Morocco"));
    addCity(_("Cayman Palms"), "America/Cayman", _("Cayman Islands"));
    addCity(_("Chicago"), "America/Chicago", _("United States"));
    addCity(_("Chihuahua"), "America/Chihuahua", _("Mexico"));
    addCity(_("Chişinău"), "Europe/Chisinau", _("Moldova"));
    addCity(_("Cincinnati"), "America/New_York", _("United States"));
    addCity(_("Cleveland"), "America/New_York", _("United States"));
    addCity(_("Colombo"), "Asia/Colombo", _("Sri Lanka"));
    addCity(_("Columbus"), "America/New_York", _("United States"));
    addCity(_("Conakry"), "Africa/Conakry", _("Guinea"));
    addCity(_("Copenhagen"), "Europe/Copenhagen", _("Denmark"));
    addCity(_("Costa Rica"), "America/Costa_Rica", _("Costa Rica"));
    addCity(_("Curaçao"), "America/Curacao", _("Curacao"));

    addCity(_("Dakar"), "Africa/Dakar", _("Senegal"));
    addCity(_("Dallas"), "America/Chicago", _("United States"));
    addCity(_("Damascus"), "Asia/Damascus", _("Syria"));
    addCity(_("Dar es Salaam"), "Africa/Dar_es_Salaam", _("Tanzania"));
    addCity(_("Darwin"), "Australia/Darwin", _("Australia"));
    addCity(_("Dawson Creek"), "America/Dawson_Creek", _("Canada"));
    addCity(_("Delhi"), "Asia/Kolkata", _("India"));
    addCity(_("Denver"), "America/Denver", _("United States"));
    addCity(_("Detroit"), "America/Detroit", _("United States"));
    addCity(_("Dhaka"), "Asia/Dhaka", _("Bangladesh"));
    addCity(_("Djibouti"), "Africa/Djibouti", _("Djibouti"));
    addCity(_("Doha"), "Asia/Qatar", _("Qatar"));
    addCity(_("Dominica"), "America/Dominica", _("Dominica"));
    addCity(_("Dubai"), "Asia/Dubai", _("United Arab Emirates"));
    addCity(_("Dublin"), "Europe/Dublin", _("Ireland"));

    addCity(_("Easter Island"), "Pacific/Easter", _("Chile"));
    addCity(_("Edmonton"), "America/Edmonton", _("Canada"));
    addCity(_("El Salvador"), "America/El_Salvador", _("El Salvador"));

    addCity(_("Fiji"), "Pacific/Fiji", _("Fiji"));
    addCity(_("Fortaleza"), "America/Fortaleza", _("Brazil"));
    addCity(_("Frankfurt"), "Europe/Berlin", _("Germany"));
    addCity(_("Freetown"), "Africa/Freetown", _("Sierra Leone"));

    addCity(_("Gaborone"), "Africa/Gaborone", _("Botswana"));
    addCity(_("Gaza"), "Asia/Gaza", _("Palestine"));
    addCity(_("Gibraltar"), "Europe/Gibraltar", _("Gibraltar"));
    addCity(_("Grand Turk"), "America/Grand_Turk", _("Turks and Caicos Islands"));
    addCity(_("Grenada"), "America/Grenada", _("Grenada"));
    addCity(_("Guam"), "Pacific/Guam", _("Guam"));
    addCity(_("Guangzhou"), "Asia/Shanghai", _("China"));
    addCity(_("Guatemala"), "America/Guatemala", _("Guatemala"));
    addCity(_("Gurgaon"), "Asia/Kolkata", _("India"));
    addCity(_("Guyana"), "America/Guyana", _("Guyana"));

    addCity(_("Haifa"), "Asia/Jerusalem", _("Israel"));
    addCity(_("Halifax"), "America/Halifax", _("Canada"));
    addCity(_("Hamburg"), "Europe/Berlin", _("Germany"));
    addCity(_("Hanoi"), "Asia/Ho_Chi_Minh", _("Vietnam"));
    addCity(_("Harare"), "Africa/Harare", _("Zimbabwe"));
    addCity(_("Havana"), "America/Havana", _("Cuba"));
    addCity(_("Hebron"), "Asia/Hebron", _("Palestine"));
    addCity(_("Helsinki"), "Europe/Helsinki", _("Finland"));
    addCity(_("Ho Chi Minh City"), "Asia/Ho_Chi_Minh", _("Vietnam"));
    addCity(_("Hong Kong"), "Asia/Hong_Kong", _("Hong Kong"));
    addCity(_("Honolulu"), "Pacific/Honolulu", _("United States"));
    addCity(_("Houston"), "America/Chicago", _("United States"));
    addCity(_("Hyderabad"), "Asia/Kolkata", _("India"));

    addCity(_("Indianapolis"), "America/Indiana/Indianapolis", _("United States"));
    addCity(_("Islamabad"), "Asia/Karachi", _("Pakistan"));
    addCity(_("Isle of Man"), "Europe/Isle_of_Man", _("Isle of Man"));
    addCity(_("Istanbul"), "Europe/Istanbul", _("Turkey"));

    addCity(_("Jacksonville"), "America/New_York", _("United States"));
    addCity(_("Jakarta"), "Asia/Jakarta", _("Indonesia"));
    addCity(_("Jerusalem"), "Asia/Jerusalem", _("Israel"));
    addCity(_("Johannesburg"), "Africa/Johannesburg", _("South Africa"));

    addCity(_("Kabul"), "Asia/Kabul", _("Afghanistan"));
    addCity(_("Kampala"), "Africa/Kampala", _("Uganda"));
    addCity(_("Karachi"), "Asia/Karachi", _("Pakistan"));
    addCity(_("Khartoum"), "Africa/Khartoum", _("Sudan"));
    addCity(_("Kiev"), "Europe/Kiev", _("Ukraine"));
    addCity(_("Kigali"), "Africa/Kigali", _("Rwanda"));
    addCity(_("Kingston"), "America/Toronto", _("Canada"));
    addCity(_("Kinshasa"), "Africa/Kinshasa", _("Democratic Republic of the Congo"));
    addCity(_("Kiritimati"), "Pacific/Kiritimati", _("Kiribati"));
    addCity(_("Kirkland"), "America/Montreal", _("Canada"));
    addCity(_("Knox"), "Australia/Melbourne", _("Australia"));
    addCity(_("Knoxville"), "America/New_York", _("United States"));
    addCity(_("Kraków"), "Europe/Warsaw", _("Poland"));
    addCity(_("Kuala Lumpur"), "Asia/Kuala_Lumpur", _("Malaysia"));
    addCity(_("Kuwait City"), "Asia/Kuwait", _("Kuwait"));
    addCity(_("Kyiv"), "Europe/Kiev", _("Ukraine"));

    addCity(_("Lagos"), "Africa/Lagos", _("Nigeria"));
    addCity(_("Lahore"), "Asia/Karachi", _("Pakistan"));
    addCity(_("Las Vegas"), "America/Los_Angeles", _("United States"));
    addCity(_("Lima"), "America/Lima", _("Peru"));
    addCity(_("Lisbon"), "Europe/Lisbon", _("Portugal"));
    addCity(_("London"), "Europe/London", _("United Kingdom"));
    addCity(_("Longyearbyen"), "Arctic/Longyearbyen", _("Svalbard and Jan Mayen"));
    addCity(_("Los Angeles"), "America/Los_Angeles", _("United States"));
    addCity(_("Louisville"), "America/Kentucky/Louisville", _("United States"));
    addCity(_("Luxembourg"), "Europe/Luxembourg", _("Luxembourg"));

    addCity(_("Macau"), "Asia/Macau", _("Macao"));
    addCity(_("Madison"), "America/Chicago", _("United States"));
    addCity(_("Madrid"), "Europe/Madrid", _("Spain"));
    addCity(_("Maldives"), "Indian/Maldives", _("Maldives"));
    addCity(_("Malta"), "Europe/Malta", _("Malta"));
    addCity(_("Managua"), "America/Managua", _("Nicaragua"));
    addCity(_("Manchester"), "Europe/London", _("United Kingdom"));
    addCity(_("Manila"), "Asia/Manila", _("Philippines"));
    addCity(_("Marengo"), "America/Indiana/Marengo", _("United States"));
    addCity(_("Martinique"), "America/Martinique", _("Canada"));
    addCity(_("Maseru"), "Africa/Maseru", _("Lesotho"));
    addCity(_("Melbourne"), "Australia/Melbourne", _("Australia"));
    addCity(_("Memphis"), "America/Chicago", _("United States"));
    addCity(_("Mendoza"), "America/Argentina/Mendoza", _("Argentina"));
    addCity(_("Metlakatla"), "America/Metlakatla", _("United States"));
    addCity(_("Mexico City"), "America/Mexico_City", _("Mexico"));
    addCity(_("Miami"), "America/New_York", _("United States"));
    addCity(_("Milan"), "Europe/Rome", _("Italy"));
    addCity(_("Milwaukee"), "America/Chicago", _("United States"));
    addCity(_("Minneapolis"), "America/Chicago", _("United States"));
    addCity(_("Minsk"), "Europe/Minsk", _("Belarus"));
    addCity(_("Mogadishu"), "Africa/Mogadishu", _("Somalia"));
    addCity(_("Monrovia"), "Africa/Monrovia", _("Liberia"));
    addCity(_("Monaco"), "Europe/Monaco", _("Monaco"));
    addCity(_("Monterrey"), "America/Monterrey", _("Mexico"));
    addCity(_("Montevideo"), "America/Montevideo", _("Uruguay"));
    addCity(_("Montreal"), "America/Montreal", _("Canada"));
    addCity(_("Moscow"), "Europe/Moscow", _("Russia"));
    addCity(_("Mountain View"), "America/Los_Angeles", _("United States"));
    addCity(_("Mumbai"), "Asia/Kolkata", _("India"));
    addCity(_("Munich"), "Europe/Berlin", _("Germany"));
    addCity(_("Muscat"), "Asia/Muscat", _("Oman"));

    addCity(_("Nairobi"), "Africa/Nairobi", _("Kenya"));
    addCity(_("Nashville"), "America/Chicago", _("United States"));
    addCity(_("Nassau"), "America/Nassau", _("Bahamas"));
    addCity(_("New Orleans"), "America/Chicago", _("United States"));
    addCity(_("New Salem"), "America/North_Dakota/New_Salem", _("United States"));
    addCity(_("New South Wales"), "Australia/Sydney", _("Australia"));
    addCity(_("New York"), "America/New_York", _("United States"));
    addCity(_("Newfoundland"), "America/St_Johns", _("United States"));
    addCity(_("Nouméa"), "Pacific/Noumea", _("New Caledonia"));
    addCity(_("Nuestra Señora de La Paz"), "America/Bogota", _("Colombia"));

    addCity(_("Oklahoma City"), "America/Chicago", _("United States"));
    addCity(_("Osaka"), "Asia/Tokyo", _("Japan"));
    addCity(_("Oslo"), "Europe/Oslo", _("Norway"));
    addCity(_("Ottawa"), "America/Toronto", _("Canada"));
    addCity(_("Oulu"), "Europe/Helsinki", _("Finland"));

    addCity(_("Panamá"), "America/Panama", _("Panama"));
    addCity(_("Paramaribo"), "America/Paramaribo", _("Suriname"));
    addCity(_("Paris"), "Europe/Paris", _("France"));
    addCity(_("Perth"), "Australia/Perth", _("Australia"));
    addCity(_("Petersburg"), "America/Indiana/Petersburg", _("Russia"));
    addCity(_("Philadelphia"), "America/New_York", _("United States"));
    addCity(_("Phnom Penh"), "Asia/Phnom_Penh", _("Cambodia"));
    addCity(_("Phoenix"), "America/Phoenix", _("United States"));
    addCity(_("Pittsburgh"), "America/New_York", _("United States"));
    addCity(_("Port of Spain"), "America/Port_of_Spain", _("Trinidad and Tobago"));
    addCity(_("Port au Prince"), "America/Port-au-Prince", _("Haiti"));
    addCity(_("Portland"), "America/Los_Angeles", _("United States"));
    addCity(_("Prague"), "Europe/Prague", _("Czech"));
    addCity(_("Pyongyang"), "Asia/Pyongyang", _("North Korea"));

    addCity(_("Queensland"), "Australia/Brisbane", _("United States"));
    addCity(_("Quito"), "America/Guayaquil", _("Ecuador"));

    addCity(_("Rangoon"), "Asia/Rangoon", _("Myanmar"));
    addCity(_("Reno"), "America/Los_Angeles", _("United States"));
    addCity(_("Reston"), "America/New_York", _("United States"));
    addCity(_("Reykjavík"), "Atlantic/Reykjavik", _("Iceland"));
    addCity(_("Riga"), "Europe/Riga", _("Latvia"));
    addCity(_("Rio de Janeiro"), "America/Sao_Paulo", _("Brazil"));
    addCity(_("Riyadh"), "Asia/Riyadh", _("Saudi Arabia"));
    addCity(_("Rome"), "Europe/Rome", _("Italy"));

    addCity(_("Sacramento"), "America/Los_Angeles", _("United States"));
    addCity(_("Salt Lake City"), "America/Denver", _("United States"));
    addCity(_("Samoa"), "Pacific/Apia", _("Samoa"));
    addCity(_("San Antonio"), "America/Chicago", _("United States"));
    addCity(_("San Diego"), "America/Los_Angeles", _("United States"));
    addCity(_("San Francisco"), "America/Costa_Rica", _("United States"));
    addCity(_("San José"), "America/Costa_Rica", _("Costa Rica"));
    addCity(_("San Juan"), "America/Puerto_Rico", _("Puerto Rico"));
    addCity(_("San Marino"), "Europe/San_Marino", _("San Marino"));
    addCity(_("San Salvador"), "America/El_Salvador", _("El Salvador"));
    addCity(_("Sanaa"), "Asia/Aden", _("Yemen"));
    addCity(_("Santiago"), "America/Santiago", _("Chile"));
    addCity(_("Santo Domingo"), "America/Santo_Domingo", _("Dominican Republic"));
    addCity(_("São Paulo"), "America/Sao_Paulo", _("Brazil"));
    addCity(_("São Tomé"), "Africa/Sao_Tome", _("São Tomé and Príncipe"));
    addCity(_("Sarajevo"), "Europe/Sarajevo", _("Bosnia and Herzegovina"));
    addCity(_("Saskatchewan"), "America/Regina", _("Canada"));
    addCity(_("Seattle"), "America/Los_Angeles", _("United States"));
    addCity(_("Seoul"), "Asia/Seoul", _("South Korea"));
    addCity(_("Shanghai"), "Asia/Shanghai", _("China"));
    addCity(_("Singapore"), "Asia/Singapore", _("Singapore"));
    addCity(_("Simferopol’"), "Europe/Simferopol", _("Ukraine"));
    addCity(_("Skopje"), "Europe/Skopje", _("Macedonia"));
    addCity(_("Sofia"), "Europe/Sofia", _("Bulgaria"));
    addCity(_("St.Johns"), "America/St_Johns", _("Canada"));
    addCity(_("St.Kitts"), "America/St_Kitts", _("Saint Kitts and Nevis"));
    addCity(_("St.Louis"), "America/Chicago", _("United States"));
    addCity(_("Stanley"), "Atlantic/Stanley", _("Falkland Islands"));
    addCity(_("Stockholm"), "Europe/Stockholm", _("Sweden"));
    addCity(_("Suva"), "Pacific/Fiji", _("Fiji"));
    addCity(_("Sydney"), "Australia/Sydney", _("Australia"));

    addCity(_("Taipei"), "Asia/Taipei", _("Taiwan"));
    addCity(_("Tallinn"), "Europe/Tallinn", _("Estonia"));
    addCity(_("Tehran"), "Asia/Tehran", _("Iran"));
    addCity(_("Tokyo"), "Asia/Tokyo", _("Japan"));
    addCity(_("Toronto"), "America/Toronto", _("Canada"));
    addCity(_("Tripoli"), "Africa/Tripoli", _("Libyra"));
    addCity(_("Tunis"), "Africa/Tunis", _("Tunisia"));

    addCity(_("Ulan Bator"), "Asia/Ulan_Bator", _("Mongolia"));
    addCity(_("UTC"), "UTC", _("UTC"));

    addCity(_("Vancouver"), "America/Vancouver", _("Canada"));
    addCity(_("Vatican City"), "Europe/Vatican", _("Vatican City"));
    addCity(_("Vevay"), "America/Indiana/Vevay", _("United States"));
    addCity(_("Vienna"), "Europe/Vienna", _("Austria"));
    addCity(_("Vilnius"), "Europe/Vilnius", _("Lithuania"));
    addCity(_("Vincennes"), "America/Indiana/Vincennes", _("France"));

    addCity(_("Warsaw"), "Europe/Warsaw", _("Poland"));
    addCity(_("Washington D.C"), "America/New_York", _("United States"));
    addCity(_("Winamac"), "America/Indiana/Winamac", _("United States"));
    addCity(_("Winnipeg"), "America/Winnipeg", _("Canada"));
    addCity(_("Wrocław"), "Europe/Warsaw", _("Poland"));

    addCity(_("Zagreb"), "Europe/Zagreb", _("Croatia"));
    addCity(_("Zürich"), "Europe/Zurich", _("Switzerland"));

    // Let QML know model is reusable again
    endResetModel();
}
