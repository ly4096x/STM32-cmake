IF(NOT CHIBIOS_ROOT)
    MESSAGE(FATAL_ERROR "No CHIBIOS_ROOT specified, using default: ${CHIBIOS_ROOT}")
ENDIF()


MESSAGE(STATUS "Chibios version:" ${ChibiOS_FIND_VERSION_MAJOR})

IF(ChibiOS_FIND_VERSION_MAJOR EQUAL 2)
  MESSAGE(FATAL_ERROR "ChibiOS v2.x.x is not supported. Use older version of stm32-cmake")
ELSEIF((ChibiOS_FIND_VERSION_MAJOR EQUAL 19))
  INCLUDE(ChibiOS/19/ChibiOS)
ELSEIF((ChibiOS_FIND_VERSION_MAJOR EQUAL 18))
  INCLUDE(ChibiOS/18.2/ChibiOS)
ELSEIF((ChibiOS_FIND_VERSION_MAJOR EQUAL 17))
  INCLUDE(ChibiOS/ChibiOS17)
ELSEIF((ChibiOS_FIND_VERSION_MAJOR EQUAL 16))
  INCLUDE(ChibiOS/ChibiOS16)
ELSEIF((NOT ChibiOS_FIND_VERSION_MAJOR) OR (ChibiOS_FIND_VERSION_MAJOR EQUAL 3))
  INCLUDE(ChibiOS/ChibiOS3)
ENDIF()

LIST(REMOVE_DUPLICATES ChibiOS_INCLUDE_DIRS)
LIST(REMOVE_DUPLICATES ChibiOS_SOURCES)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ChibiOS DEFAULT_MSG ChibiOS_SOURCES ChibiOS_INCLUDE_DIRS ChibiOS_LINKER_SCRIPT)


