#ifndef _TEST_BASE_H_
#define _TEST_BASE_H_

#include <stdexcept>
#include <iostream>
#include <string>
#include <map>
#include <vector>

#define EPSILON    (1.0e-4)

#define TEST_CASE( name ) std::cout << (std::string(" - ") + std::string(name)) << std::endl;

#define TEST_ASSERT_THROW( condition )                              \
{                                                                   \
  if( !( condition ) )                                              \
  {                                                                 \
    throw std::runtime_error(   std::string( __FILE__ )             \
                              + std::string( ":" )                  \
                              + std::to_string( __LINE__ )          \
                              + std::string( " in " )               \
    );                                                              \
  }                                                                 \
}

#define TEST_ASSERT_EQUAL( x, y )                                   \
{                                                                   \
  if( ( x ) != ( y ) )                                              \
  {                                                                 \
    throw std::runtime_error(   std::string( __FILE__ )             \
                              + std::string( ":" )                  \
                              + std::to_string( __LINE__ )          \
                              + std::string( " in " )               \
                              + std::string( ": " )                 \
                              + std::to_string( ( x ) )             \
                              + std::string( " != " )               \
                              + std::to_string( ( y ) )             \
    );                                                              \
  }                                                                 \
}

#define TEST_ASSERT_FLOAT_EQUAL( x, y )                             \
{                                                                   \
  if( fabs( x - y ) > EPSILON )                                    \
  {                                                                 \
    throw std::runtime_error(   std::string( __FILE__ )             \
                              + std::string( ":" )                  \
                              + std::to_string( __LINE__ )          \
                              + std::string( " in " )               \
                              + std::string( ": " )                 \
                              + std::to_string( ( x ) )             \
                              + std::string( " != " )               \
                              + std::to_string( ( y ) )             \
    );                                                              \
  }                                                                 \
}

#define TEST_ASSERT_STRING_EQUAL( x, y )                            \
{                                                                   \
  if( strcmp(x, y) != 0 )                                           \
  {                                                                 \
    throw std::runtime_error(   std::string( __FILE__ )             \
                              + std::string( ":" )                  \
                              + std::to_string( __LINE__ )          \
                              + std::string( " in " )               \
                              + std::string( ": " )                 \
                              + std::string( ( x ) )                \
                              + std::string( " != " )               \
                              + std::string( ( y ) )                \
    );                                                              \
  }                                                                 \
}

#endif