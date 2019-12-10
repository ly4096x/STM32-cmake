SET(CMAKE_C_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -Wall -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "c compiler flags")
SET(CMAKE_CXX_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -Wall -Wno-register -Wno-write-strings -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "cxx compiler flags")
SET(CMAKE_ASM_FLAGS "-mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -x assembler-with-cpp" CACHE INTERNAL "asm compiler flags")

SET(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -mabi=aapcs" CACHE INTERNAL "executable linker flags")
SET(CMAKE_MODULE_LINKER_FLAGS "-mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -mabi=aapcs" CACHE INTERNAL "module linker flags")
SET(CMAKE_SHARED_LINKER_FLAGS "-mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -mabi=aapcs" CACHE INTERNAL "shared linker flags")

SET(STM32_CHIP_TYPES 405xx 415xx 407xx 417xx 427xx 437xx 429xx 439xx 446xx 401xC 401xE 411xE CACHE INTERNAL "stm32f4 chip types")
SET(STM32_CODES "405.." "415.." "407.." "417.." "427.." "437.." "429.." "439.." "446.." "401.[CB]" "401.[ED]" "411.[CE]")

MACRO(STM32_GET_CHIP_TYPE CHIP CHIP_TYPE)
    STRING(REGEX REPLACE "^[sS][tT][mM]32[fF](4[01234][15679].[BCEGI]).*$" "\\1" STM32_CODE ${CHIP})
    SET(INDEX 0)
    FOREACH(C_TYPE ${STM32_CHIP_TYPES})
        LIST(GET STM32_CODES ${INDEX} CHIP_TYPE_REGEXP)
        IF(STM32_CODE MATCHES ${CHIP_TYPE_REGEXP})
            SET(RESULT_TYPE ${C_TYPE})
        ENDIF()
        MATH(EXPR INDEX "${INDEX}+1")
    ENDFOREACH()
    SET(${CHIP_TYPE} ${RESULT_TYPE})
ENDMACRO()

MACRO(STM32_GET_CHIP_PARAMETERS CHIP FLASH_SIZE RAM_SIZE CCRAM_SIZE)
    STRING(REGEX REPLACE "^[sS][tT][mM]32[fF](4[01234][15679].[BCEGI]).*$" "\\1" STM32_CODE ${CHIP})
    STRING(REGEX REPLACE "^[sS][tT][mM]32[fF]4[01234][15679].([BCEGI]).*$" "\\1" STM32_SIZE_CODE ${CHIP})
    
    IF(STM32_SIZE_CODE STREQUAL "B")
        SET(FLASH "128K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "C")
        SET(FLASH "256K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "E")
        SET(FLASH "512K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "G")
        SET(FLASH "1024K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "I")
        SET(FLASH "2048K")
    ENDIF()
    
    STM32_GET_CHIP_TYPE(${CHIP} TYPE)
    
    IF(${TYPE} STREQUAL "401xC")
        SET(RAM "64K")
    ELSEIF(${TYPE} STREQUAL "401xE")
        SET(RAM "96K")
    ELSEIF(${TYPE} STREQUAL "411xE")
        SET(RAM "128K")
    ELSEIF(${TYPE} STREQUAL "405xx")
        SET(RAM "128K")
    ELSEIF(${TYPE} STREQUAL "415xx")
        SET(RAM "128K")
    ELSEIF(${TYPE} STREQUAL "407xx")
        SET(RAM "128K")
    ELSEIF(${TYPE} STREQUAL "417xx")
        SET(RAM "128K")
    ELSEIF(${TYPE} STREQUAL "427xx")
        SET(RAM "192K")
    ELSEIF(${TYPE} STREQUAL "437xx")
        SET(RAM "192K")
    ELSEIF(${TYPE} STREQUAL "429xx")
        SET(RAM "192K")
    ELSEIF(${TYPE} STREQUAL "439xx")
        SET(RAM "192K")
    ELSEIF(${TYPE} STREQUAL "446xx")
        SET(RAM "128K")
    ENDIF()
    
    SET(${FLASH_SIZE} ${FLASH})
    SET(${RAM_SIZE} ${RAM})
    SET(${CCRAM_SIZE} "64K")
ENDMACRO()

FUNCTION(STM32_SET_CHIP_DEFINITIONS TARGET CHIP_TYPE)
    LIST(FIND STM32_CHIP_TYPES ${CHIP_TYPE} TYPE_INDEX)
    IF(TYPE_INDEX EQUAL -1)
        MESSAGE(FATAL_ERROR "Invalid/unsupported STM32F4 chip type: ${CHIP_TYPE}")
    ENDIF()
    GET_TARGET_PROPERTY(TARGET_DEFS ${TARGET} COMPILE_DEFINITIONS)
    IF(TARGET_DEFS)
        SET(TARGET_DEFS "STM32F4;STM32F${CHIP_TYPE};${TARGET_DEFS}")
    ELSE()
        SET(TARGET_DEFS "STM32F4;STM32F${CHIP_TYPE}")
    ENDIF()
        
    SET_TARGET_PROPERTIES(${TARGET} PROPERTIES COMPILE_DEFINITIONS "${TARGET_DEFS}")
ENDFUNCTION()
