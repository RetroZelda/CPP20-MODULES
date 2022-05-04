#pragma once

#include <string>

enum ELogLevel
{
    Verbose,
    Warning,
    Error,
    Critical
};

void Log(std::string text, ELogLevel log_level);