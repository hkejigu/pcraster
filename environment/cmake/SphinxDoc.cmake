CONFIGURE_FILE(
  ${CMAKE_CURRENT_SOURCE_DIR}/conf.py.in
  ${CMAKE_CURRENT_BINARY_DIR}/conf.py
)
CONFIGURE_FILE(
  # Don't name the new file Makefile, as it conflicts with the CMake generated
  # file.
  ${CMAKE_CURRENT_SOURCE_DIR}/Makefile.in
  ${CMAKE_CURRENT_BINARY_DIR}/Makefile-sphinx
)

FOREACH(NAME ${SPHINX_SOURCES})
  SET(SPHINX_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/${NAME})
  SET(COPIED_SPHINX_SOURCE ${CMAKE_CURRENT_BINARY_DIR}/${NAME})
  ADD_CUSTOM_COMMAND(
    OUTPUT ${COPIED_SPHINX_SOURCE}
    COMMAND ${CMAKE_COMMAND} -E copy ${SPHINX_SOURCE} ${COPIED_SPHINX_SOURCE}
    DEPENDS ${SPHINX_SOURCE}
  )
  LIST(APPEND COPIED_SPHINX_SOURCES ${COPIED_SPHINX_SOURCE})
ENDFOREACH()

FOREACH(NAME _build _static _templates)
  ADD_CUSTOM_COMMAND(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${NAME}
    COMMAND ${CMAKE_COMMAND} -E make_directory
      ${CMAKE_CURRENT_BINARY_DIR}/${NAME}
  )
ENDFOREACH()

SET(SPHINX_SPHINXOPTS "-q -W")
# SET(SPHINX_PAPER a4)

ADD_CUSTOM_COMMAND(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/_build/html/index.html
  COMMAND make SPHINXOPTS=${SPHINX_SPHINXOPTS} -C ${CMAKE_CURRENT_BINARY_DIR} -f Makefile-sphinx html
  DEPENDS
    ${CMAKE_CURRENT_BINARY_DIR}/conf.py
    ${CMAKE_CURRENT_BINARY_DIR}/Makefile-sphinx
    ${CMAKE_CURRENT_BINARY_DIR}/_build
    ${CMAKE_CURRENT_BINARY_DIR}/_static
    ${CMAKE_CURRENT_BINARY_DIR}/_templates
    ${COPIED_SPHINX_SOURCES}
)

ADD_CUSTOM_TARGET(${SPHINX_TARGET} ALL
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/_build/html/index.html
)


FUNCTION(DOCUMENT_PYTHON_API)
    SET(OPTIONS "")
    SET(ONE_VALUE_ARGUMENTS TARGET SOURCE_DIRECTORY BINARY_DIRECTORY)
    SET(MULTI_VALUE_ARGUMENTS "")

    CMAKE_PARSE_ARGUMENTS(PYTHON_API "${OPTIONS}" "${ONE_VALUE_ARGUMENTS}"
        "${MULTI_VALUE_ARGUMENTS}" ${ARGN})

    IF(PYTHON_API_UNPARSED_ARGUMENTS)
        MESSAGE(FATAL_ERROR
            "Macro called with unrecognized arguments: "
            "${PYTHON_API_UNPARSED_ARGUMENTS}")
    ENDIF()

    ADD_CUSTOM_COMMAND(
        OUTPUT ${PYTHON_API_BINARY_DIRECTORY}/modules.rst
        COMMAND sphinx-apidoc -o ${PYTHON_API_BINARY_DIRECTORY}
            ${PYTHON_API_SOURCE_DIRECTORY}
        DEPENDS
            ${PYTHON_API_SOURCE_DIRECTORY}/__init__.py
    )

    ADD_CUSTOM_TARGET(${PYTHON_API_TARGET}
        DEPENDS ${PYTHON_API_BINARY_DIRECTORY}/modules.rst)
ENDFUNCTION()