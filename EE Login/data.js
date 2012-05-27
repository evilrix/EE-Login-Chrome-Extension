var re =
{
   'ee': [
      /^http:\/\/[^.]+\.experts-exchange\.com\//,
   {
      'eead': [ 'Admins Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/Admin_Only\// ],
      'eemd': [ 'Mods Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/Mods_Only\// ],
      'eeza': [ 'ZAs Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/Admin_Mod_ZA_Only\// ],
      'eepe': [ 'PEs Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/(?:PE_Adm|Admin_Mod_PE_Only)\// ],
      'eecv': [ 'CVs Only', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/CV_Admin\// ],
      'eepd': [ 'PD Zone', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/Private_Discussions\// ],
      'eecg': [ 'CS General', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/General\// ],
      'eecs': [ 'CS Other', /^http:\/\/[^.]+\.experts-exchange\.com\/Community_Support\/Hidden\/(?!Admin_Only|Mods_Only|Admin_Mod_ZA_Only|Admin_Mod_PE_Only|Private_Discussions|CV_Admin)\// ],
      'eera': [ 'RA Zone', /^http:\/\/[^.]+\.experts-exchange\.com\/R_\d+\.html$/ ],
      'eear': [ 'Articles', /^http:\/\/[^.]+\.experts-exchange\.com\/.+\/A_.+\.html$/ ]
   } ],
   'es': [
      /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/?/,
   {
      'esgd': [ 'EE Stuff God', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/God\// ],
      'esad': [ 'EE Stuff Admin', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/Admin\// ],
      'esmd': [ 'EE Stuff Mod', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/Mod\// ],
      'esza': [ 'EE Stuff ZA', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/ZA\// ],
      'espe': [ 'EE Stuff PE', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/PE\// ],
      'escv': [ 'EE Stuff CV', /^http:\/\/(?:[^.]+\.)?ee-stuff\.com\/CV\// ]
   } ]
};

var urlRe = /^https?:\/\/[^/]+/

