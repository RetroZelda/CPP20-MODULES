#include "logger_legacy.h"

#include <iostream>

const char* LogLevelToString(ELogLevel log_level)
{
    switch(log_level)
    {
        case ELogLevel::Verbose  : return "[VERBOSE]";
        case ELogLevel::Warning  : return "[WARNING]";
        case ELogLevel::Error    : return "[ERROR]";
        case ELogLevel::Critical : return "[CRITICAL]";
    }
    return "[BAD]";
}

void Log(std::string text, ELogLevel log_level)
{
    std::cout << LogLevelToString(log_level) << " " << text << std::endl;
} 

