Census County Level Confounders Using Tidycensus
================
Ben Sabath
May 05, 2020

This code creates a pipeline for downloading county level census data
from the US census. With minimal adjustments, this could be adapted to
work for any geographical level that we’re interested in.

The output data files are located in
`ci3_confounders/data_for_analysis/prepped_census`

The interpolated data is named `census_county_interpolated.csv` The
uninterpolated data is named `census_county_uninterpolated.csv`

## Data Availability

  - ACS Data is available from 2009 onward
  - Decennial Data is available in 2000 and 2010

## Census Variable Lists

  - 2000 Census:
      - SF1 (Whole US sample, not all questions asked):
        <https://api.census.gov/data/2000/sf1/variables.html>
      - SF3 (more detailed, smaller sample):
        <https://www.census.gov/data/developers/data-sets/decennial-census.2000.html>
  - 2010 Census (because of course they’re not consistent):
      - SF1: <https://api.census.gov/data/2010/dec/sf1/variables.html>
  - ACS List:
    <https://www.census.gov/data/developers/data-sets/acs-5year.html>

## Adding New Variables

The variables used to create the census data are formally described in
the yaml file `code/census_vars.yml`. Each variable is defined by a top
level entry in this file. The format for a variable is as follows:

``` yaml
<var_name>:
    <year>:
        <source>:
            num:
                 - <numerator_variable_1>
                 - <numerator_variable_2>
            [den]:
                 - <denominator_variable_1>
                 - <denominator_variable_2>
```

These descriptions provide instructions to the code on which variables
to ask for from which api and how to calculate the desired variable from
the information availablie in the API.

#### Field Definitions

  - `var_name`: The user chosen name for a variable
  - `year`: Which year the specification should be used for. The code
    uses the specification for the closest year to the input year that
    is current with or after the input year.
  - `source`: This should be either “census” or “acs”. If it is census,
    the code knows to make the call for this variable from the decennial
    census, and if acs the code uses the 5 year ACS data. As a reminder,
    decennial census data is available in 2000 and 2010, and ACS data is
    available 2009-2018. Some variables present in the 2000 census are
    not available in the 2010 decennial census.
  - `num`: This field should always be named “num”. All variables listed
    in this field are summed and divided by the sum of the `den`
    variables. If no `den` field is present, the sum of these fields
    will be the value reported for the variable
  - `den`: An optional field. This must always be named `den`. The
    variables listed here are summed, and then the sum of the numerator
    variables is divided by this to produce the final reported value.

#### Examples

  - % of the population that is Black.

<!-- end list -->

``` yaml
blk_pct:
    2000:
        census:
            num: P007003
            den: P007001
    2009: 
        acs:
            num: B02001_003
            den: B02001_001
    2010:
        census:
            num: P006003
            den: P006001
    2018: 
        acs:
            num: B02001_003
            den: B02001_001
```

Here a variable named `blk_pct` will be created. In 2000, the census
data will be used, and the variable will be calculated as
`P007003/P007001`. In 2009, ACS data will be used, and the variable will
be calculated as `B02001_003/B02001_001`. In 2010, back the the census
data and the variable will be calculated as `P007003/P007001`. Then
finally, from 2011-2018, ACS data will be used and the variable will be
calculated as `B02001_003/B02001_001`.

  - Median Household Income

<!-- end list -->

``` yaml
median_household_income:
    2000:
        census:
            num: P053001
    2018:
        acs:
            num: B19013_001
```

Here a variable named `median_household_income` will be created. Note
the lack of a denominator. In 2000, the census variable `P053001` is
reported. This value was missing from the 2010 census, so from 2009-2018
the acs variable `B19013_001` will be used instead.

## Defining Variables

  - Poverty Rate (No Poverty info in 2010 decennial census, use ACS
    after 2000):
      - Whole Population:
          - 2000 Census: `P087002/P087001`
          - ACS: `(B17001_002/B17002_001` Income under P line over total
            population with poverty status known
      - Above 65:
          - 2000 Census: Poverty info only available broken down by age,
            race, sex. Have to reconstruct our variables: `P087008 +
            P087009/P087008 + P087009 + P087016 + P087017`
          - ACS: `(B17001_015 + B17001_016 + B17001_030 +
            B17001_031)/(B17001_015 + B17001_016 + B17001_030 +
            B17001_031 + B17001_044 + B17001_045 + B17001_058 +
            B17001_059` (Men 65 + below poverty line + women 65+ below
            poverty line/Men 65+ below poverty line + women 65+ below
            poverty line + Men 65+ above poverty line + women 65+ above
            poverty line)
  - Population Density:
      - Getting Population Area: Use tigris package to download
        counties, use ALAND (ALAND 10 for ZCTA) term/2589988 (to convert
        to sq miles).
      - Whole Population:
          - Census: `P001001`
          - ACS: `B00001_001`
  - Median House Value
      - Not in 2010 Census
      - Whole Population
          - ACS: `B25077_001`
          - 2000 Census: `H076001`
  - Race:
      - Whole Population:
          - 2000 Census(SF1):
              - Total Pop: `P007001`
              - White Pop: `P007002`
              - Black Pop: `P007003`
              - Indigenous Pop: `P007004`
              - Asian Pop: `P007005`
          - 2010 Census(SF1) (P006 in 2010, P007 in 2000):
              - Total Pop: `P006001`
              - White Pop: `P006002`
              - Black Pop: `P006003`
              - Indigenous Pop: `P006004`
              - Asian Pop: `P006005`
          - ACS:
              - Total Pop: `B02001_001`
              - White Pop: `B02001_002`
              - Black Pop: `B02001_003`
              - Indigenous Pop: `B02001_004`
              - Asian Pop: `B02001_005`
  - Median Household Income:
      - Use ACS for 2010, not in 2010 census
      - 2000 Census: `P053001`
      - ACS: `B19013_001`
  - Hispanic:
      - Whole Population:
          - 2000 Census(SF1): `P004002/P004001`
          - 2010 Census (SF1): `P004003/P004001`
          - ACS: `B03003_003/B03003_001`
  - % of the population not graduating high school
      - No data in 2010 decennial, use ACS. Data is available broken
        down by gender and age, need to create full data
      - whole population
          - 2000
            Census:
        <!-- end list -->
            (PCT025004 + PCT025005 + PCT025012 + PCT025013 + PCT025020 + PCT025021 + 
            PCT025028 + PCT025029 + PCT025036 + PCT025037 + PCT025045 + PCT025046 + PCT025053 + PCT025054
            + PCT025061 + PCT025062 + PCT025069 + PCT025070 + PCT025078 + PCT025079)/(PCT025002 + PCT025043)
          - ACS:
        <!-- end list -->
            (B15001_004 + B15001_005 + B15001_012 + B15001_013 + B15001_020 + B15001_021 + B15001_028 +
            B15001_029 + B15001_036 + B15001_037 + B15001_045 + B15001_046 + B15001_053 + B15001_054 + 
            B15001_060 + B15001_061 + B15001_069 + B15001_070 + B15001_077 + B15001_078)/(B15001_002 + B15001_043)
      - older than 65:
          - 2000 Census: `(PCT025036 + PCT025037 + PCT025077 +
            PCT025078)/(PCT025035 + PCT025076)`
          - ACS: `(B15001_036 + B15001_037 + B15001_077 +
            B15001_078)/(B15001_035 + B15001_076)`
  - Owner Occupied Housing
      - Whole Population
          - 2000 Census (SF1): `(H004002/H004001)`
          - 2010 Census (SF1): `(H004002 + H004003)/H004001`
          - ACS: `B25003_002/B25003_001`
  - Median Age:
      - Census: P013001
      - ACS: B01002\_001
  - Age Percentages
      - Census:
          - Total [Pop:\`P012001](Pop:%60P012001)\`
          - 0-15: `P012003 + P012004 + P012005 + P012027 + P012028 +
            P012029`
          - 15-44: `P012006 + P012007 + P012008 + P012009 + P012010 +
            P012011 + P012012 + P012013 + P012014 + P012030 + P012031 +
            P012032 + P012033 + P012034 + P012035 + P012036 + P012037 +
            P012038`
          - 45-64: `P012015 + P012016 + P012017 + P012018 + P012019 +
            P012039 + P012040 + P012041 + P012042 + P012043`
          - 65+: `P012020 + P012021 + P012022 + P012023 + P012024 +
            P012025 + P012044 + P012045 + P012046 + P012047 + P012048 +
            P012049`
      - ACS:
          - Total [Pop:\`B01001\_001](Pop:%60B01001_001)\`
          - 0-15: `B01001_003 + B01001_004 + B01001_005 + B01001_027 +
            B01001_028 + B01001_029`
          - 15-44: `B01001_006 + B01001_007 + B01001_008 + B01001_009 +
            B01001_010 + B01001_011 + B01001_012 + B01001_013 +
            B01001_014 + B01001_030 + B01001_031 + B01001_032 +
            B01001_033 + B01001_034 + B01001_035 + B01001_036 +
            B01001_037 + B01001_038`
          - 45-64: `B01001_015 + B01001_016 + B01001_017 + B01001_018 +
            B01001_019 + B01001_039 + B01001_040 + B01001_041 +
            B01001_042 + B01001_043`
          - 65+: `B01001_020 + B01001_021 + B01001_022 + B01001_023 +
            B01001_024 + B01001_025 + B01001_044 + B01001_045 +
            B01001_046 + B01001_047 + B01001_048 + B01001_049`
