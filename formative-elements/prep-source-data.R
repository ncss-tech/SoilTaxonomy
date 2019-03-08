# ele <- readClipboard()
# def <- readClipboard()

ele <- c("Alb", "Anthr", "Aqu", "Ar", "Arg", "Calc", 
         "Camb", "Cry", "Dur", "Fibr", "Fluv", "Fol", "Gyps", "Hem", "Hist", 
         "Hum", "Orth", "Per", "Psamm", "Rend", "Sal", "Sapr", "Torr", 
         "Turb", "Ud", "Vitr", "Ust", "Xer", "Acr", 
         "Al", "Alb", "Anhy", "Anthr", "Aqu", "Argi", "Calci, calc", "Cry", 
         "Dur", "Dystr, dys", "Endo", "Epi", "Eutr", "Ferr", "Fibr", "Fluv", 
         "Fol", "Fragi", "Fragloss", "Fulv", "Glac", "Gyps", "Gloss", 
         "Hal", "Hapl", "Hem", "Hist", "Hum", "Hydr", "Kand, kan", "Luv", 
         "Melan", "Moll", "Natr", "Pale", "Petr", "Plac", "Plagg", "Plinth", 
         "Psamm", "Quartz", "Rhod", "Sal", "Sapr", "Somb", "Sphagn", "Sulf", 
         "Torr", "Ud", "Umbr", "Ust", "Verm", "Vitr", "Xer"
)

def <- c("Presence of albic horizon", "Modified by humans", 
         "Aquic conditions", "Mixed horizons", "Presence of argillic horizon", 
         "Presence of a calcic horizons", "Presence of a cambic horizon", 
         "Cold", "Presence of a duripan", "Least decomposed stage", "Flood plain", 
         "Mass of leaves", "Presence of a gypsic horizon", "Intermediate stage of decomposition", 
         "Presence of organic materials", "Presence of organic matter", 
         "The common ones", "Perudic moisture regime", "Sandy texture", 
         "High carbonate content", "Presence of a salic horizon", "Most decomposed stage", 
         "Torric moisture regime", "Presence of cryoturbation", "Udic moisture regime", 
         "Presence of glass", "Ustic moisture regime", "Xeric moisture regime", 
         "Extreme weathering", "High aluminum, low iron", 
         "An albic horizon", "Very dry", "An anthropic epipedon", "Aquic conditions", 
         "Presence of an argillic horizon", "A calcic horizon", "Cold", 
         "A duripan", "Low base saturation", "Implying a ground water table", 
         "Implying a perched water table", "High base saturation", "Presence of iron", 
         "Least decomposed stage", "Flood plain", "Mass of leaves", "Presence of fragipan", 
         "See the formative elements \"frag\" and \"gloss\"", "Dark brown color, presence of organic carbon", 
         "Ice lenses or wedges", "Presence of gypsic horizon", "Presence of a glossic horizon", 
         "Salty", "Minimum horizon development", "Intermediate stage of decomposition", 
         "Presence of organic materials", "Presence of organic matter", 
         "Presence of water", "1:1 layer silicate clays", "Illuvial", 
         "Black, presence of organic carbon", "Presence of a mollic epipedon", 
         "Presence of natric horizon", "Excessive development", "A cemented horizon", 
         "Presence of thin pan", "Presence of plaggen epipedon", "Presence of plinthite", 
         "Sandy texture", "High quartz content", "Dark red color", "Presence of salic horizon", 
         "Most decomposed stage", "Presence of sombric horizon", "Presence of Sphagnum", 
         "Presence of sulfides or their oxidation products", "Torric moisture regime", 
         "Udic moisture regime", "Presence of umbric epipedon", "Ustic moisture regime", 
         "Wormy, or mixed by animals", "Presence of glass", "Xeric moisture regime"
)

d <- data.frame(element=ele, definition=def, stringsAsFactors = FALSE)

d <- unique(d)

write.csv(d, file='formative-elements-draft.csv', row.names = FALSE)


## manually remove multi-word entries

