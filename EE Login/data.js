var re =
{
   'ee': { 'name': 'Experts Exchange', 'regex': [
      /^http:\/\/[^.]+\.experts-exchange\.com\//,
      {
         'eead': [ 'Admins&nbsp;Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/Admin_Only\// ],
         'eemd': [ 'Mods&nbsp;Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/Mods_Only\// ],
         'eeza': [ 'ZAs&nbsp;Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/Admin_Mod_ZA_Only\// ],
         'eepe': [ 'PEs&nbsp;Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/(?:PE_Adm|Admin_Mod_PE_Only)\// ],
         'eecv': [ 'CVs&nbsp;Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/CV_Admin\// ],
         'eepd': [ 'PD&nbsp;Zone', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/Private_Discussions\// ],
         'eecg': [ 'CS&nbsp;General', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/General\// ],
         'eecs': [ 'CS&nbsp;Other', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/(?!Admin_Only|Mods_Only|Admin_Mod_ZA_Only|Admin_Mod_PE_Only|Private_Discussions|CV_Admin)\// ],
         'eera': [ 'RA&nbsp;Zone', /^http:\/\/[^.]+\.experts-exchange\.com\/R_\d+\.html$/ ],
         'eear': [ 'Articles', /^http:\/\/[^.]+\.experts-exchange\.com\/.+\/A_.+\.html$/ ]
      } ] },
   'es': { 'name': 'EE Stuff', 'regex': [
      /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/?/,
      {
         'esad': [ 'Admin Area', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/Admin\// ],
         'esmd': [ 'Mod Area', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/Mod\// ],
         'esza': [ 'ZA Area', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/ZA\// ],
         'espe': [ 'PE Area', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/PE\// ],
         'escv': [ 'CV Area', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/CV\// ]
      } ] }
};

var urlRe = /^https?:\/\/[^/]+/

