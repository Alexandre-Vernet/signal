package com.avernet.signal.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ApiException.class)
    public ResponseEntity<?> exceptionHandler(ApiException apiException) {
        return new ResponseEntity<>(
            new ApiErrorResponse(
                apiException.getErrorCode(),
                apiException.getMessage(),
                apiException.getHttpStatus()
            ),
            apiException.getHttpStatus());
    }
}
