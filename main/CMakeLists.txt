idf_component_register(SRCS "filament_dryer_box_main.cpp")

#idf_component_get_property(cname main COMPONENT_NAME)
#idf_component_get_property(clib main COMPONENT_LIB)
#idf_component_get_property(calias main COMPONENT_ALIAS)
#message(STATUS ${cname})
#message(STATUS ${clib})
#message(STATUS ${calias})
#add_custom_command(
#        TARGET ${cname}
#        POST_BUILD
#        COMMAND "${CMAKE_OBJCOPY} ARGS -O ihex ${CMAKE_PROJECT_NAME}.elf ${CMAKE_PROJECT_NAME}.hex"
#)