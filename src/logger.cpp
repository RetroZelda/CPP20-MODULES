module;

#include <iostream>

export module Logger;
export import <string>;

export enum ELogLevel
{
    Verbose,
    Warning,
    Error,
    Critical
};

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

export void Log(std::string text, ELogLevel log_level)
{
    std::cout << LogLevelToString(log_level) << " " << text << std::endl;
} 

