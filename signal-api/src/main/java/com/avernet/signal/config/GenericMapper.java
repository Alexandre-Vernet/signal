package com.avernet.signal.config;

import java.util.List;

public interface GenericMapper<D, E> {
    D toDto(E entity);

    List<D> toDtoList(List<E> entityList);

    E toEntity(D dto);

    List<E> toEntityList(List<D> dtoList);
}
